#!/usr/bin/env bash
# Removes the symlinks and ~/.zshrc lines created by the playbook,
# restoring any configs that were backed up during setup.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ansible-playbook "$DOTFILES_DIR/ansible/uninstall.yaml"
