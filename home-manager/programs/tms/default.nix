{
  pkgs,
  configDir,
  workspaceDir,
  ...
}: {
  # Minimal replacement for tmux-sessionizer (tms)
  home.packages = [
    (pkgs.writers.writeFishBin "tms"
      # fish
      ''
        set -l fzf ${pkgs.fzf}/bin/fzf --preview-window right,75% --list-border --input-border

        switch "$argv[1]"
            case "" # pick a git repo, create or switch to its session
                set -l dir (${pkgs.fd}/bin/fd -H -d 6 '^\.git$' "${configDir}" "${workspaceDir}" -x dirname | sort | $fzf)
                or exit
                set -l name (path basename $dir | string replace -a . _)
                tmux has-session -t "=$name" 2>/dev/null
                or tmux new-session -ds $name -c $dir
                if set -q TMUX
                    tmux switch-client -t "=$name"
                else
                    tmux attach -t "=$name"
                end
            case switch # ctrl-x kills the highlighted session
                set -l list "tmux list-sessions -F '#{session_last_attached} #{session_name}' | sort -rn | cut -d' ' -f2- | grep -vxF \"\$(tmux display -p '#S')\""
                set -l name (fish -c $list | $fzf --preview 'tmux capture-pane -ep -t {}' \
                    --header 'ctrl-x: kill session' --bind "ctrl-x:execute-silent(tmux kill-session -t ={})+reload($list)")
                or exit
                tmux switch-client -t "=$name"
            case windows
                set -l win (tmux list-windows -F '#{window_index} #{window_name}' | $fzf --preview 'tmux capture-pane -ep -t :{1}')
                or exit
                tmux select-window -t :(string split -f1 ' ' $win)
            case kill # kill current session, move to the last one first
                set -l current (tmux display -p '#S')
                tmux switch-client -l 2>/dev/null
                tmux kill-session -t "=$current"
            case '*'
                echo "usage: tms [switch|windows|kill]" >&2
                exit 1
        end
      '')
  ];
}
