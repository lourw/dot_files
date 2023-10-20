run_hook() {
  HOOK_FILE_NAME="$1"
  SOURCE_PATH="$2"
  TARGET_PATH="$3"
  
  if [ -d "./hooks" ]; then
    echo "No Hooks Detected"
    return 0
  fi

  HOOK_PATH="$CUR_DIR/scripts/hooks/$HOOK_FILE_NAME"
  if [ -f "$HOOK_PATH" ]; then
    echo "Executing hook: [$HOOK_FILE_NAME]"
    chmod +x "$HOOK_PATH"
    "$HOOK_PATH" "$SOURCE_PATH" "$TARGET_PATH"
  fi
}
