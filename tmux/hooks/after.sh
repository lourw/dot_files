SOURCE_PATH="$1"
TARGET_PATH="$2"

if [[ -z $SOURCE_PATH || -z $TARGET_PATH ]]; then
  echo "Invalid source [$SOURCE_PATH] or target [$TARGET_PATH]"
  exit 0
fi

if [[ ! -d "${SOURCE_PATH}plugins/tpm" ]]; then
  echo "-> Cloning TPM into ${SOURCE_PATH}plugins/tpm"
  git clone https://github.com/tmux-plugins/tpm "${SOURCE_PATH}plugins/tpm"
else
  echo "-> TPM source already exists in [${SOURCE_PATH}plugins/tpm]"
fi

  
