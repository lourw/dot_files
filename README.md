# Dotfiles
This is my personal repo for UNIX/LINUX systems that I work with. I don't like having to reconfigure my environment everytime I switch devices so I put them all here. 

## Setup 
Install Nix package manager with `sh <(curl -L https://nixos.org/nix/install) --daemon` from [Nix Download](https://nixos.org/download)
Install home-manager with the following command `nix run home-manager -- init --switch`
To install all configs, just run `./install.sh`
Switch home-manager to the configuration in this repo `home-manager switch --impure`. Since nix is functional, commands to grab values from ENV variables are considered 'impure', we need the flag to ensure we can find the system's username and home path.

