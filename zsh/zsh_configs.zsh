# ==========================
# --- CONFIGS START HERE ---
# ==========================
#
# --- ALIASES ---
alias zshconfig='nvim ~/.zsh_configs.zsh && source ~/.zsh_configs.zsh'
alias vimconfig='nvim ~/.config/nvim/lua/configs'
alias tmuxconfig='nvim ~/.tmux.conf'
alias ls="ls --color=auto"
alias vim='nvim'
alias e='nvim'
alias home='cd ~'

alias precommit-config='nvim .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit'

alias notes='cd ~/notes && nvim $(date '+%Y-%m-%d').md'

# --- GIT ---
alias rebase='git fetch origin main:main && git rebase main'

# --- NODE ---
alias npm='pnpm'

# --- ZSH CONFIGS ---
autoload -Uz compinit && compinit

