#!/bin/bash
CUR_DIR="$(cd "$(dirname -- "$1")" > /dev/null; pwd -P)$(basename -- "$1")"

DOTFILES=(
  "tmux:tmux.conf:.tmux.conf"
  "nvim::.config/nvim"
  "zsh:zshconf:.zshconf"
  "fd:fdignore:.fdignore"
)

echo "Running setup script for dot env files..."
echo "========================================="

# SCRIPT IMPORTS
HOOK_HELPER_SCRIPT="./scripts/run_hooks.sh"
source "$HOOK_HELPER_SCRIPT"

if [[ -z $HOME ]]; then
  echo "No home variable set"
  exit 1
fi

for dot_file in ${DOTFILES[*]} 
do
  SOURCE_DIR="$CUR_DIR/$(echo $dot_file | cut -d ":" -f 1)"
  SOURCE_PATH="$SOURCE_DIR/$(echo $dot_file | cut -d ":" -f 2)"
  TARGET_PATH="$HOME/$(echo $dot_file | cut -d ":" -f 3)"
  echo "Adding [$SOURCE_PATH] to [$TARGET_PATH]"  

  if [ -L "$TARGET_PATH" ]; then
    echo "-> Removing existing link at $TARGET_PATH"
    rm "$TARGET_PATH"
  fi

  echo "-> Creating link for $TARGET_PATH"
  ln -s "$SOURCE_PATH" "$TARGET_PATH"
  
  run_hook "after.sh" "$SOURCE_DIR" "$SOURCE_PATH" "$TARGET_PATH"
done


