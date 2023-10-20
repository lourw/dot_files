CUR_DIR=$(shell pwd)
# Target Paths
#
NVIM_PATH=~/.config/nvim
TMUX_PATH=~/.tmux.conf
ZSH_CONFIG_PATH=~/.zshconf
FD_IGNORE_PATH=~/.fdignore

PATHS := ${NVIM_PATH} ${TMUX_PATH} ${ZSH_CONFIG_PATH} ${FD_IGNORE_PATH}

regenerate: clean setup

setup: setup_nvim setup_tmux setup_zsh setup_fd_ignore

setup_nvim:
	ln -s ${CUR_DIR}/nvim ${NVIM_PATH}

setup_tmux:
	ln -s ${CUR_DIR}/tmux/tmux.conf ${TMUX_PATH}

setup_zsh:
	ln -s ${CUR_DIR}/zsh/zshconf ${ZSH_CONFIG_PATH} & \
	grep -qxF "source ${ZSH_CONFIG_PATH}" ~/.zshrc || echo "source ${ZSH_CONFIG_PATH}" >> ~/.zshrc 

setup_fd_ignore:
	ln -s ${CUR_DIR}/fd/fdignore ${FD_IGNORE_PATH}

clean:
	rm $(PATHS)
