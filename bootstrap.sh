#!/usr/bin/env bash
# One-command setup for a new machine:
#   curl -fsSL https://raw.githubusercontent.com/lourw/dot_files/main/bootstrap.sh | bash
#
# Installs git + ansible, clones this repo (if needed) and runs the playbook.
# Set DOTFILES_DIR to clone somewhere other than ~/.config/dot_files.
set -euo pipefail

REPO_HTTPS="https://github.com/lourw/dot_files.git"
REPO_SSH="git@github.com:lourw/dot_files.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.config/dot_files}"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

install_prereqs() {
  case "$(uname -s)" in
    Darwin)
      if ! command -v brew >/dev/null 2>&1; then
        info "Installing Homebrew"
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
      if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
      fi
      info "Installing git and ansible"
      brew install git ansible
      ;;
    Linux)
      [ -r /etc/os-release ] || die "Cannot detect Linux distribution"
      # shellcheck disable=SC1091
      . /etc/os-release
      case "${ID} ${ID_LIKE:-}" in
        *arch*)
          info "Installing git and ansible via pacman"
          sudo pacman -Sy --needed --noconfirm git ansible
          ;;
        *fedora*)
          info "Installing git and ansible via dnf"
          sudo dnf install -y git ansible
          ;;
        *debian*|*ubuntu*)
          info "Installing git and ansible via apt"
          sudo apt-get update
          sudo apt-get install -y git ansible
          ;;
        *) die "Unsupported distribution: ${ID}" ;;
      esac
      ;;
    *) die "Unsupported OS: $(uname -s)" ;;
  esac
}

clone_repo() {
  if [ -d "$DOTFILES_DIR/.git" ]; then
    info "Using existing checkout at $DOTFILES_DIR"
    return
  fi
  [ -e "$DOTFILES_DIR" ] && die "$DOTFILES_DIR exists but is not a git checkout"

  info "Cloning dotfiles into $DOTFILES_DIR"
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  # Clone over HTTPS (no SSH keys on a fresh machine), then switch to SSH for pushing
  git clone "$REPO_HTTPS" "$DOTFILES_DIR"
  git -C "$DOTFILES_DIR" remote set-url origin "$REPO_SSH"
}

run_playbook() {
  info "Running ansible playbook"
  if sudo -n true 2>/dev/null; then
    # Passwordless sudo (e.g. CI): no prompt, and there may be no tty
    ansible-playbook "$DOTFILES_DIR/ansible/playbook.yaml"
  else
    # Read the become password from the terminal, since stdin is the curl pipe
    ansible-playbook "$DOTFILES_DIR/ansible/playbook.yaml" --ask-become-pass </dev/tty
  fi
}

install_prereqs
clone_repo
run_playbook
info "Done. Restart your shell to pick up the new config."
