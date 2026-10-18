# Dotfiles
This is my personal repo for UNIX/LINUX systems that I work with. I don't like having to reconfigure my environment everytime I switch devices so I put them all here. 

# Getting Started
On a new machine, run:

```sh
curl -fsSL https://raw.githubusercontent.com/lourw/dot_files/main/bootstrap.sh | bash
```

This installs `git` and `ansible` (plus Homebrew on macOS), clones the repo into
`~/.config/dot_files`, and runs the playbook. It will prompt for your sudo password.

- To clone somewhere else: `curl -fsSL ... | DOTFILES_DIR=~/code/dot_files bash`
- If the repo is already cloned, run `./bootstrap.sh` from it (or the `ap` alias) to re-apply.
- Existing configs that would be replaced by a symlink are moved to `<path>.bak.<timestamp>`.

## Mac Setup
Ansible allows me to programmtically download all my brew dependencies in one command. I also use a tool called `mise` to help control versions for tools like `python`, `node`, `go`. 

## Arch Setup
Ensure that you have both `pacman` and `yay` configured. You will need to manually install
`powerlevel10k` using `yay`. Since it is not an official package from the AUR, I opted to not
automatically download it here. 
