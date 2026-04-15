#!/usr/bin/env fish
set input (cat)

set MODEL (echo $input | jq -r '.model.display_name')
set PCT (echo $input | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
set COST (echo $input | jq -r '.cost.total_cost_usd // 0')
set DURATION_MS (echo $input | jq -r '.cost.total_duration_ms // 0')
set VIM_MODE (echo $input | jq -r '.vim.mode // empty')

set DIM '\033[2m'
set CYAN '\033[36m'
set GREEN '\033[32m'
set YELLOW '\033[33m'
set RED '\033[31m'
set BOLD '\033[1m'
set RESET '\033[0m'

# context bar with color
if test "$PCT" -ge 90
    set COLOR $RED
else if test "$PCT" -ge 70
    set COLOR $YELLOW
else
    set COLOR $GREEN
end

set FILLED (math "floor($PCT / 5)")
set EMPTY (math "20 - $FILLED")
set BAR ""
for i in (seq $FILLED)
    set BAR "$BAR━"
end
for i in (seq $EMPTY)
    set BAR "$BAR╌"
end

# cost
set COST_FMT (printf '$%.2f' "$COST")

# duration
set MINS (math "floor($DURATION_MS / 60000)")
set SECS (math "floor(($DURATION_MS % 60000) / 1000)")
if test "$MINS" -gt 0
    set TIME "$MINS"m"$SECS"s
else
    set TIME "$SECS"s
end

# vim mode indicator
set MODE ""
if test -n "$VIM_MODE"
    if test "$VIM_MODE" = NORMAL
        set MODE "$BOLD""$CYAN"NOR"$RESET "
    else
        set MODE "$BOLD""$GREEN"INS"$RESET "
    end
end

# git branch
set BRANCH ""
if git rev-parse --git-dir >/dev/null 2>&1
    set BRANCH (git branch --show-current 2>/dev/null)
end

# line 1: mode + model + branch
set L1 "$MODE""$DIM""$MODEL""$RESET"
if test -n "$BRANCH"
    set L1 "$L1 ""$DIM"on"$RESET $CYAN""$BRANCH""$RESET"
end

# line 2: context bar + cost + time
set L2 "$COLOR""$BAR""$RESET $DIM""$PCT""%""$RESET  $YELLOW""$COST_FMT""$RESET  $DIM""$TIME""$RESET"

echo -e $L1
echo -e $L2
