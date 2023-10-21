run_hook() {
  HOOK_FILE_NAME="$1"
  SOURCE_DIR="$2"
  SOURCE_PATH="$3"
  TARGET_PATH="$4"
  
  if [ ! -d "$SOURCE_DIR/hooks" ]; then
    return 0
  fi

  HOOK_PATH="$SOURCE_DIR/hooks/$HOOK_FILE_NAME"
  if [ -f "$HOOK_PATH" ]; then
    echo "Executing hook: [$HOOK_FILE_NAME]"
    chmod +x "$HOOK_PATH"
    "$HOOK_PATH" "$SOURCE_PATH" "$TARGET_PATH"
  fi
}
