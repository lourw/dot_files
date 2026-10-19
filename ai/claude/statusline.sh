#!/bin/sh
# Claude Code status line: the model, the session's folder, (inside a linked worktree)
# the worktree name, the git branch, how full the context window is, the prompt cache
# hit rate and the session's cost and duration, in the colours of the shared theme. Claude Code pipes the session as JSON on stdin; installed by
# merge-hooks.sh.

# colours from the shared palette: set -g @theme_<name> "<colour>" -> $theme_<name>
eval "$(sed -n 's/^set -g @theme_\([a-z_]*\)  *"\([^"]*\)".*/theme_\1="\2"/p' ~/.config/theme/current.tmux 2>/dev/null)"

# tmux colour (#rrggbb or a basic name) -> ANSI foreground escape
fg() {
  case $1 in
    \#*) printf '\033[38;2;%d;%d;%dm' "0x$(echo "$1" | cut -c2-3)" "0x$(echo "$1" | cut -c4-5)" "0x$(echo "$1" | cut -c6-7)" ;;
    black) printf '\033[30m' ;; red) printf '\033[31m' ;; green) printf '\033[32m' ;;
    yellow) printf '\033[33m' ;; blue) printf '\033[34m' ;; magenta) printf '\033[35m' ;;
    cyan) printf '\033[36m' ;; white) printf '\033[37m' ;; *) printf '\033[39m' ;;
  esac
}
reset='\033[0m'

input=$(cat)
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd')
context=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty | floor')
# share of the last request's prompt served from the prompt cache
cache=$(printf '%s' "$input" | jq -r '.context_window.current_usage // empty
  | ((.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)) as $total
  | if $total > 0 then (.cache_read_input_tokens // 0) * 100 / $total | floor else empty end')
cost=$(printf '%s' "$input" | jq -r '.cost.total_cost_usd // empty')
# session wall time as 1h 5m, 12m or 40s
duration=$(printf '%s' "$input" | jq -r '.cost.total_duration_ms // empty | . / 1000 | floor
  | if . >= 3600 then "\(. / 3600 | floor)h \(. % 3600 / 60 | floor)m"
    elif . >= 60 then "\(. / 60 | floor)m" else "\(.)s" end')
case $dir in "$HOME"*) short="~${dir#"$HOME"}" ;; *) short=$dir ;; esac

[ -n "$model" ] && printf "$(fg "$theme_fg")󰚩 %s$reset  " "$model"
printf "$(fg "$theme_accent") %s$reset" "$short"

# split the rev-parse output on newlines only, so paths with spaces survive
IFS='
'
set -- $(git -C "$dir" rev-parse --path-format=absolute --git-dir --git-common-dir --show-toplevel 2>/dev/null)
if [ $# -eq 3 ]; then
  branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null || git -C "$dir" rev-parse --short HEAD)
  # a linked worktree has its own git dir, separate from the shared one
  [ "$1" != "$2" ] && printf "  $(fg "$theme_muted")󰙅 %s$reset" "${3##*/}"
  printf "  $(fg "$theme_muted") %s$reset" "$branch"
fi
if [ -n "$context" ]; then
  # warn once the window is mostly full, ahead of auto-compaction
  [ "$context" -ge 80 ] && colour=$theme_warn || colour=$theme_subtle
  printf "  $(fg "$colour")󰍛 %s%%$reset" "$context"
fi
[ -n "$cache" ] && printf "  $(fg "$theme_subtle")󰆼 %s%%$reset" "$cache"
[ -n "$cost" ] && printf "  $(fg "$theme_subtle") %.2f$reset" "$cost"
[ -n "$duration" ] && printf "  $(fg "$theme_subtle") %s$reset" "$duration"
printf '\n'
