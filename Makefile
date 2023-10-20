CUR_DIR=$(shell pwd)

# Target Paths
NVIM_PATH=~/.config/nvim
TMUX_PATH=~/.tmux.conf

setup: clean setup_nvim setup_tmux

setup_nvim:
	ln -s ${CUR_DIR}/nvim ${NVIM_PATH}

setup_tmux:
	ln -s ${CUR_DIR}/tmux/tmux.conf ${TMUX_PATH}

clean:
	rm ${NVIM_PATH} ${TMUX_PATH}
