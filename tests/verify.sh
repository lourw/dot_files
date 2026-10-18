#!/usr/bin/env bash
# Checks the end state left by the playbook (`installed`) or uninstall.sh (`uninstalled`)
# for the current user. Exits non-zero listing every failed check.
set -uo pipefail

MODE="${1:?usage: verify.sh installed|uninstalled}"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="$HOME/.config"
failures=0

pass() { printf '  \033[32mok\033[0m   %s\n' "$*"; }
fail() { printf '  \033[31mFAIL\033[0m %s\n' "$*"; failures=$((failures + 1)); }
check() { local desc="$1"; shift; if "$@" >/dev/null 2>&1; then pass "$desc"; else fail "$desc"; fi; }

# "src dest" pairs from ansible/vars/links.yaml, with the template vars expanded
links() {
  sed -n 's/.*src: "\([^"]*\)", dest: "\([^"]*\)".*/\1 \2/p' "$DOTFILES_DIR/ansible/vars/links.yaml" |
    sed -e "s#{{ dot_files_path }}#$DOTFILES_DIR#g" -e "s#{{ config_path }}#$CONFIG#g" -e "s#{{ home_path }}#$HOME#g"
}

links_into_repo() { [ -L "$1" ] && [ "$(readlink "$1")" = "$2" ]; }

if [ "$MODE" = installed ]; then
  echo "Symlinks"
  while read -r src dest; do
    check "$dest -> $src" links_into_repo "$dest" "$src"
  done < <(links)

  echo "Backups"
  check "pre-existing nvim config moved to nvim.bak.*" bash -c "ls -d '$CONFIG'/nvim.bak.*/e2e-marker"

  echo "~/.zshrc"
  check "sources ~/.zshconf" grep -qx 'source ~/.zshconf' "$HOME/.zshrc"
  while read -r file; do
    check "sourced file exists: $file" test -f "${file/#\~/$HOME}"
  done < <(sed -n 's/^source \([^<$(][^ ]*\)$/\1/p' "$HOME/.zshrc")
  # Loading the full config must not print errors (missing plugins, bad aliases, mise...)
  zsh_err="$(TERM=xterm-256color zsh -i -c exit 2>&1 >/dev/null)"
  if [ -z "$zsh_err" ]; then pass "interactive zsh starts cleanly"; else fail "interactive zsh printed: $zsh_err"; fi

  echo "Tools"
  for cmd in git tmux zsh ansible-playbook; do
    check "$cmd installed" command -v "$cmd"
  done
  # Installed by mise, so only on PATH once zsh has activated it
  for cmd in mise bat fd fzf gh hx k9s kubectl kubectx kubens lazygit rg zig tree-sitter; do
    check "$cmd on PATH in zsh" zsh -ic "command -v $cmd"
  done
  # nvim-treesitter needs 0.12+; nvim comes from mise
  check "nvim 0.12+ in zsh" zsh -ic 'nvim --version | head -1 | grep -qE "v(0\.(1[2-9]|[2-9][0-9])|[1-9])"'

  echo "mise runtimes"
  for tool in node go rust; do
    check "$tool installed by mise" zsh -ic "cd ~ && mise where $tool"
  done

  echo "tmux plugins"
  for plugin in tpm tmuxifier tmux-resurrect; do
    check "$plugin" test -d "$CONFIG/tmux/plugins/$plugin"
  done

  if [ "$(uname -s)" = Linux ]; then
    echo "Login shell"
    check "login shell is zsh" bash -c "getent passwd '$(id -un)' | cut -d: -f7 | grep -q '/zsh$'"
  fi
else
  echo "Symlinks removed"
  while read -r src dest; do
    if links_into_repo "$dest" "$src"; then fail "$dest still links into the repo"; else pass "$dest"; fi
  done < <(links)

  echo "Backups restored"
  check "nvim config restored from backup" test -f "$CONFIG/nvim/e2e-marker"
  check "nvim config is not a symlink" test ! -L "$CONFIG/nvim"

  echo "~/.zshrc"
  if grep -qE 'zshconf|utils\.sh|zsh-autosuggestions|zsh-syntax-highlighting|fzf' "$HOME/.zshrc"; then
    fail "~/.zshrc still has dotfile lines: $(cat "$HOME/.zshrc")"
  else
    pass "dotfile lines removed"
  fi
fi

if [ "$failures" -gt 0 ]; then
  echo "$failures check(s) failed"
  exit 1
fi
echo "All checks passed"
