#!/bin/sh
# prints the start of status-right for the pane path $1: in a repo, a segment with the git
# branch and (inside a linked worktree) the worktree name, then the arrow that opens the
# folder segment
# split the rev-parse output on newlines only, so paths with spaces survive
IFS='
'
set -- $(git -C "$1" rev-parse --path-format=absolute --git-dir --git-common-dir --show-toplevel 2>/dev/null) "$1"
if [ $# -eq 4 ]; then
  branch=$(git -C "$4" symbolic-ref --short HEAD 2>/dev/null || git -C "$4" rev-parse --short HEAD)
  printf '#[fg=#292e42,bg=#16161e]#[fg=#a9b1d6,bg=#292e42]  %s ' "$branch"
  # a linked worktree has its own git dir, separate from the shared one
  [ "$1" != "$2" ] && printf '#[fg=#565f89]#[fg=#a9b1d6] 󰙅 %s ' "${3##*/}"
  printf '#[fg=green,bg=#292e42]'
else
  printf '#[fg=green,bg=#16161e]'
fi
