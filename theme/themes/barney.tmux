# Green theme: tmux's standard green on Tokyo Night greys.
# Themes are shared by tmux and the zsh prompt; theme/current.tmux links to the active one
# (switch with the `theme` command). tmux uses the options as #{@theme_<name>};
# zsh/prompt.zsh and tmux/scripts/git-branch.sh read the same lines, so keep each one in
# the form: set -g @theme_<name> "<colour>"
set -g @theme_bg         "#16161e"   # bar and dark backgrounds
set -g @theme_on_accent  "#16161e"   # text on accent blocks
set -g @theme_surface    "#292e42"   # grey segments and inactive tabs
set -g @theme_fg         "#c0caf5"   # main text
set -g @theme_muted      "#a9b1d6"   # dimmer text: inactive tabs, branch and worktree
set -g @theme_subtle     "#565f89"   # thin dividers
set -g @theme_accent     "green"     # active tab, folder, session block, prompt icon
set -g @theme_warn       "yellow"    # prefix held, Claude waiting
set -g @theme_error      "red"       # prompt char after a failed command
