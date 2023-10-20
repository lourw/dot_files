#!/bin/bash
CUR_DIR="$(cd "$(dirname -- "$1")" > /dev/null; pwd -P)$(basename -- "$1")"


DOTFILES=(
  "tmux/tmux.conf:.tmux.conf"
  "nvim:.config/nvim"
  "zsh/zshconf:.zshconf"
  "fd/fdignore:.fdignore"
)

echo "Running setup script for dot env files..."
echo "========================================="

# SCRIPT IMPORTS
HOOK_HELPER_SCRIPT="./scripts/run_hooks.sh"
chmod +x "$HOOK_HELPER_SCRIPT"
source "$HOOK_HELPER_SCRIPT"

if [[ -z $HOME ]]; then
  echo "No home variable set"
  exit 1
fi

for dot_file in ${DOTFILES[*]} 
do
  SOURCE_PATH="$CUR_DIR/$(echo $dot_file | cut -d ":" -f 1)"
  TARGET_PATH="$HOME/$(echo $dot_file | cut -d ":" -f 2)"
  echo "Adding [$SOURCE_PATH] to [$TARGET_PATH]"  

  if [ -L "$TARGET_PATH" ]; then
    echo "Removing existing link at $TARGET_PATH"
    rm "$TARGET_PATH"
  fi

  echo "Creating link for $TARGET_PATH"
  ln -s "$SOURCE_PATH" "$TARGET_PATH"
  echo "..."
done

run_hook "after.sh" "$SOURCE_PATH" "$TARGET_PATH"

