#!/bin/sh
# prints a status-right segment with the git branch of $1, or nothing outside a repo
branch=$(git -C "$1" symbolic-ref --short HEAD 2>/dev/null || git -C "$1" rev-parse --short HEAD 2>/dev/null)
[ -n "$branch" ] && printf '#[fg=green,bg=#292e42]#[fg=#16161e,bg=green,bold]  %s ' "$branch"
exit 0
