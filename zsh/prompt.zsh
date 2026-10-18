# zsh prompt, sourced by zshconf
# Colours come from the active theme, ~/.config/theme/current.tmux, a link to one of
# theme/themes/*.tmux: set -g @theme_<name> "<colour>" -> $theme[<name>]
typeset -gA theme
_theme_link=$HOME/.config/theme/current.tmux
_theme_load() {
  local _set _flag name value _rest
  # no active theme (missing or renamed): fall back to the first one
  if [[ ! -r $_theme_link ]]; then
    local -a themes=(${_theme_link:h}/themes/*.tmux(N))
    (( $#themes )) || { print -u2 "theme: no themes in ${_theme_link:h}/themes"; return 1 }
    ln -sfn themes/${themes[1]:t} $_theme_link
    print -u2 "theme: no active theme found, fell back to ${themes[1]:t:r}"
    _theme_tmux_reload
  fi
  theme=()
  while read -r _set _flag name value _rest; do
    [[ $name == @theme_* ]] && theme[${name#@theme_}]=${(Q)value}
  done < $_theme_link
  _theme_file=${_theme_link:A}
}
_theme_tmux_reload() {
  tmux source-file $_theme_link 2>/dev/null && tmux refresh-client -S 2>/dev/null
}
_theme_load

# `theme` lists the themes; `theme <name>` switches tmux and every open shell to it
theme() {
  local dir=~/.config/theme
  if [[ -z $1 ]]; then
    local t current=${${_theme_link:A}:t:r}
    for t in $dir/themes/*.tmux(:t:r); do
      [[ $t == $current ]] && print "* $t" || print "  $t"
    done
    return
  fi
  [[ -f $dir/themes/$1.tmux ]] || { print -u2 "theme: no theme named $1"; return 1 }
  ln -sfn themes/$1.tmux $dir/current.tmux
  _theme_tmux_reload
  _theme_load
}

# Powerline segments: an accent icon block, then a surface block with the folder and, in
# muted text, the worktree name (inside a linked worktree), the git branch and its status:
#  N untracked and  N staged files, 󰌨 N stashes, 󰁝 N / 󰁅 N commits ahead of / behind
# the upstream; the prompt char goes on its own line and turns
# the error colour after a failed command
autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:*' enable git
# the branch is message 0 and the status markers message 1, so they can be styled apart
zstyle ':vcs_info:git:*' formats '%b' ''
zstyle ':vcs_info:git:*' actionformats '%b|%a' ''
zstyle ':vcs_info:git*+set-message:*' hooks git-status
# message 1 is the markers one per line: untracked, staged, stash, ahead and behind
# counts, all from one `git status`. Its v2 headers give the stash count and, when there
# is an upstream, ahead/behind ("# branch.ab +A -B"); entries are "1"/"2" (changed or
# renamed, then XY where X is the index), "u" (unmerged) or "?" (untracked)
+vi-git-status() {
  local -i untracked staged stash ahead behind
  local -a markers
  local line
  (( $1 == 1 )) || return 0
  for line in ${(f)"$(git status --porcelain=v2 --branch --show-stash 2>/dev/null)"}; do
    case $line in
      ('# branch.ab '*) line=${line#\# branch.ab +}; ahead=${line%% *}; behind=${line##*-} ;;
      ('# stash '*) stash=${line#\# stash } ;;
      ('? '*) (( untracked++ )) ;;
      ([12]' '[^.]*|'u '*) (( staged++ )) ;;
    esac
  done
  (( untracked )) && markers+=" $untracked"
  (( staged )) && markers+=" $staged"
  (( stash )) && markers+="󰌨 $stash"
  (( ahead )) && markers+="󰁝 $ahead"
  (( behind )) && markers+="󰁅 $behind"
  hook_com[message]=${(F)markers}
  ret=1
}
# hex colours need a truecolor terminal; otherwise use the nearest 256 colour
[[ $COLORTERM == (24bit|truecolor) ]] || zmodload zsh/nearcolor

# whether $PWD is inside a git work tree, found by looking for .git (a dir, or a file in
# worktrees and submodules) up to / without running git
_prompt_in_git() {
  [[ -n $GIT_DIR ]] && return 0
  local dir=$PWD
  while true; do
    [[ -e $dir/.git ]] && return 0
    [[ $dir == / ]] && return 1
    dir=${dir:h}
  done
}

_prompt_precmd() {
  # another shell may have switched themes
  [[ ${_theme_link:A} == $_theme_file ]] || _theme_load
  # outside a repo skip vcs_info and its git calls entirely
  if _prompt_in_git; then
    vcs_info
  else
    vcs_info_msg_0_= vcs_info_msg_1_=
  fi
  PROMPT="%K{$theme[accent]}%F{$theme[on_accent]}  %F{$theme[accent]}%K{$theme[surface]}%F{$theme[fg]}  %3~ "
  if [[ -n $vcs_info_msg_0_ ]]; then
    PROMPT+="%F{$theme[subtle]}%F{$theme[muted]} "
    # in a linked worktree the git dir differs from the shared one; show its name
    local -a git_dirs=("${(@f)$(git rev-parse --git-dir --git-common-dir --show-toplevel 2>/dev/null)}")
    if [[ ${git_dirs[1]:A} != ${git_dirs[2]:A} ]]; then
      PROMPT+="󰙅 ${${git_dirs[3]:t}//\%/%%} %F{$theme[subtle]}%F{$theme[muted]} "
    fi
    PROMPT+=" ${vcs_info_msg_0_//\%/%%} "
    [[ -n $vcs_info_msg_1_ ]] && PROMPT+=" ${(pj: :)${(f)vcs_info_msg_1_}} "
  fi
  PROMPT+="%k%F{$theme[surface]}%f"
  PROMPT+=$'\n'"%(?.%F{$theme[accent]}.%F{$theme[error]})❯%f "
  _prompt_full=$PROMPT
}
add-zsh-hook precmd _prompt_precmd

# Transient prompt: once a command is entered (or the line is cancelled with ctrl-c),
# redraw its prompt as just the prompt char so scrollback stays compact. precmd doesn't
# run after ctrl-c, so each new line restores the full prompt itself.
_prompt_transient() {
  PROMPT="%(?.%F{$theme[accent]}.%F{$theme[error]})❯%f "
  zle reset-prompt
}
_prompt_restore() {
  [[ $PROMPT == $_prompt_full ]] && return
  PROMPT=$_prompt_full
  zle reset-prompt
}
TRAPINT() {
  zle && _prompt_transient
  return $(( 128 + $1 ))
}
autoload -Uz add-zle-hook-widget
add-zle-hook-widget zle-line-finish _prompt_transient
add-zle-hook-widget zle-line-init _prompt_restore
