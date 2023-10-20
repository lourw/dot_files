SOURCE_PATH="$1"
TARGET_PATH="$2"

if [[ -z $SOURCE_PATH || -z $TARGET_PATH ]]; then
  echo "Invalid source [$SOURCE_PATH] or target [$TARGET_PATH]"
  exit 0
fi

echo "Adding reference to zshconf to .zshrc"
grep -qxF "source $TARGET_PATH" ~/.zshrc || echo "source $TARGET_PATH" >> ~/.zshrc
source ~/.zshrc
