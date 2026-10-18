#!/bin/sh
# prints the start of status-right for the pane path $1: in a repo, a segment with the git
# branch and (inside a linked worktree) the worktree name, then the arrow that opens the
# folder segment

# colours from the shared palette: set -g @theme_<name> "<colour>" -> $theme_<name>
eval "$(sed -n 's/^set -g @theme_\([a-z_]*\)  *"\([^"]*\)".*/theme_\1="\2"/p' ~/.config/theme/current.tmux 2>/dev/null)"
# split the rev-parse output on newlines only, so paths with spaces survive
IFS='
'
set -- $(git -C "$1" rev-parse --path-format=absolute --git-dir --git-common-dir --show-toplevel 2>/dev/null) "$1"
if [ $# -eq 4 ]; then
  branch=$(git -C "$4" symbolic-ref --short HEAD 2>/dev/null || git -C "$4" rev-parse --short HEAD)
  printf "#[fg=$theme_surface,bg=$theme_bg]#[fg=$theme_muted,bg=$theme_surface]  %s " "$branch"
  # a linked worktree has its own git dir, separate from the shared one
  [ "$1" != "$2" ] && printf "#[fg=$theme_subtle]#[fg=$theme_muted] 󰙅 %s " "${3##*/}"
  printf "#[fg=$theme_accent,bg=$theme_surface]"
else
  printf "#[fg=$theme_accent,bg=$theme_bg]"
fi
