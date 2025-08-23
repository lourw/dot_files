# Dotfiles
This is my personal repo for UNIX/LINUX systems that I work with. I don't like having to reconfigure my environment everytime I switch devices so I put them all here. 

# Getting Started
Make sure that you have `ansible` installed in your machine. Go to the `ansible` folder in this repository and run `ansible-playbook playbook.yaml --ask-become-pass`. Where the `--ask-become-pass` flag is used to elevate privileges for necessary tasks.

## Mac Setup
Ansible allows me to programmtically download all my brew dependencies in one command. I also use a tool called `mise` to help control versions for tools like `python`, `node`, `go`. 

## Arch Setup
Ensure that you have both `pacman` and `yay` configured. You will need to manually install
`powerlevel10k` using `yay`. Since it is not an official package from the AUR, I opted to not
automatically download it here. 
