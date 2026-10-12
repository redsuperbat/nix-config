#!/usr/bin/env fish
# Workmux agent dashboard in the current terminal: agent list on the left, live preview on the right.
# List: j/k move, i insert mode, enter jump to agent, q quit.
# Insert mode: every key goes to the agent, ctrl+q returns to the list.

function agents
    workmux status --all --json | jq -r '.agents[] | [
        .pane_id,
        ({working: "🤖", waiting: "💬", done: "✅"}[.status] // "  "),
        "\(.project)/\(.worktree)",
        .title
    ] | @tsv'
end

function cleanup
    stty $saved_stty
    printf '\e[?2004l\e[?7h\e[?25h\e[?1049l'
end

set saved_stty (stty -g)
trap 'cleanup; exit' INT TERM HUP
# Raw so ctrl+c etc. reach the agent; reads time out after 0.2s so the screen keeps redrawing.
stty raw -echo min 0 time 2
printf '\e[?1049h\e[?7l\e[?25l\e[?2004h' # alt screen, no wrap, hidden cursor, bracketed paste

set E \e # escape char; frames are printed as data, so agent output with % or \ stays intact
set rows
set sel 1
set insert 0
set tick 0
while true
    if test (math $tick % 10) -eq 0 # refresh the agent list every ~2s
        set -l current (string split -f1 \t -- $rows[$sel])
        set rows (agents)
        set sel (contains -i -- "$current" (string split -f1 \t -- $rows); or math "max(1, min($sel, $(count $rows)))")
    end
    set tick (math $tick + 1)
    set -l target (string split -f1 \t -- $rows[$sel])

    # Draw: list column on the left, preview in a box on the right (green while in insert mode).
    set -l size (stty size | string split ' ')
    set -l h $size[1]
    set -l w $size[2]
    set -l listw (math "floor($w * 0.3)")
    set -l bx (math $listw + 1) # box left edge column
    set -l ch (math $h - 2) # preview content rows
    set -l bc $E'[2m'
    set -l title ' PREVIEW · i to type '
    if test $insert = 1
        set bc $E'[1;32m'
        set title ' INSERT · keys go to the agent · ctrl+q back to list '
    end
    set -l lines
    set -l cursor
    # pane id, height, cursor x/y, cursor visible; the id check skips agents whose pane is gone
    set -l p (test -n "$target"; and tmux display -p -t $target '#{pane_id} #{pane_height} #{cursor_x} #{cursor_y} #{cursor_flag}' 2>/dev/null | string split ' ')
    if test "$p[1]" = "$target" -a (count $p) -eq 5
        set -e p[1]
        set lines (tmux capture-pane -ep -t $target 2>/dev/null)
        # Show the rows ending at the last non-blank line or the cursor, whichever is lower.
        set -l last (count $lines)
        while test $last -gt 0; and not string match -qr '\S' -- $lines[$last]
            set last (math $last - 1)
        end
        set last (math "max($last, $p[3] + 1)")
        set -l start (math "max(0, $last - $ch)")
        set lines $lines[(math $start + 1)..$last]
        set -l cy (math 2 + $p[3] - $start)
        set -l cx (math $bx + 1 + $p[2])
        test "$p[4]" = 1 -a $cy -ge 2 -a $cx -lt $w; and set cursor $E"[$cy;$cx""H"$E'[?25h'
    end
    set -l frame $E'[?25l'$E'[H'
    set -l fill (math "max(0, $w - $bx - 1 - $(string length -- $title))")
    set frame $frame$E"[1;$bx""H"$bc"╭$title$(string repeat -n $fill ─)╮"$E'[0m'
    set frame $frame$E"[$h;$bx""H"$bc"╰$(string repeat -n (math $w - $bx - 1) ─)╯"$E'[0m'
    for r in (seq $h)
        set -l left ''
        if test $r -le (count $rows)
            set -l f (string split \t -- $rows[$r])
            set left (string shorten -m (math $listw - 1) -- " $f[2] $f[3]  $f[4]")
        else if test $r -eq $h
            set left ' j/k · i insert · enter jump · q quit'
        end
        set left (string pad -r -w $listw -- (string shorten -m $listw -- $left))
        test $r -eq $sel; and set left $E'[7m'$left$E'[0m'
        test $r -eq $h -a $r -gt (count $rows); and set left $E'[2m'$left$E'[0m'
        set frame $frame$E"[$r;1H"$left
        if test $r -gt 1 -a $r -lt $h
            set -l i (math $r - 1)
            set frame $frame$bc'│'$E'[0m'"$lines[$i]"$E'[0m'$E'[K'$E"[$r;$w""H"$bc'│'$E'[0m'
        end
    end
    printf '%s' $frame $cursor

    set -l hex (dd bs=1024 count=1 2>/dev/null | od -An -v -tx1 | string split -n ' ')
    test -z "$hex"; and continue
    if test $insert = 1
        if contains 11 $hex # ctrl+q
            set insert 0
        else if test -n "$target"
            tmux send-keys -t $target -H $hex
        end
        continue
    end
    switch (string join '' $hex)
        case 6a 1b5b42 # j, down
            test $sel -lt (count $rows); and set sel (math $sel + 1)
        case 6b 1b5b41 # k, up
            test $sel -gt 1; and set sel (math $sel - 1)
        case 69 # i
            test -n "$target"; and set insert 1
        case 0d 0a # enter: jump and close, so a popup doesn't stay on top
            if test -n "$target"
                tmux switch-client -t $target
                cleanup
                exit
            end
        case 71 03 # q, ctrl+c
            cleanup
            exit
    end
end
