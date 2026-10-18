#!/usr/bin/env bash
# End-to-end test of bootstrap.sh and uninstall.sh for the current user.
# Needs passwordless sudo. Meant for throwaway machines (CI runners, containers):
# it installs packages, changes the login shell and rewrites ~/.config.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES_DIR

step() { printf '\n\033[1;35m### %s\033[0m\n' "$*"; }

step "Seed an existing config, which setup should back up"
mkdir -p "$HOME/.config/nvim"
touch "$HOME/.config/nvim/e2e-marker"

step "Run bootstrap.sh"
bash "$DOTFILES_DIR/bootstrap.sh"

step "Verify installed state"
bash "$DOTFILES_DIR/tests/verify.sh" installed

step "Re-run the playbook: it should succeed and change nothing"
recap="$(ansible-playbook "$DOTFILES_DIR/ansible/playbook.yaml" | tee /dev/stderr | grep -A1 '^PLAY RECAP' | tail -1)"
if ! grep -q 'changed=0 .*failed=0' <<<"$recap"; then
  echo "Second run was not idempotent: $recap"
  exit 1
fi

step "Run uninstall.sh"
bash "$DOTFILES_DIR/uninstall.sh"

step "Verify uninstalled state"
bash "$DOTFILES_DIR/tests/verify.sh" uninstalled
