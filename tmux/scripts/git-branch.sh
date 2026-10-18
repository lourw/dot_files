#!/bin/sh
# prints the start of status-right: a git branch segment for $1 (when it is in a
# repo) followed by the arrow that opens the folder segment
branch=$(git -C "$1" symbolic-ref --short HEAD 2>/dev/null || git -C "$1" rev-parse --short HEAD 2>/dev/null)
if [ -n "$branch" ]; then
  printf '#[fg=green,bg=#16161e]#[fg=#16161e,bg=green,bold]  %s #[fg=#292e42,bg=green,nobold]' "$branch"
else
  printf '#[fg=#292e42,bg=#16161e]'
fi
