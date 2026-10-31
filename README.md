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

# Uninstalling
Run `./uninstall.sh` from the repo. It removes every symlink and `~/.zshrc` line the playbook
created and restores the most recent `*.bak.*` backup of anything it replaced. Installed
packages, mise runtimes and your login shell are left as-is. Then delete the repo.

# Adding a New Dotfile
1. Put the config in the repo (e.g. `foo/config.toml`).
2. Add a line to `dotfile_links` in `ansible/vars/links.yaml` (setup and uninstall both use it):
   `- { src: "{{ dot_files_path }}/foo", dest: "{{ config_path }}/foo" }`
3. If it needs a package, add it to `ansible/vars/packages-common.yaml` (or a per-OS list).
   If Fedora names it differently or doesn't have it, add it to `packages_dnf_exclude`
   in `ansible/vars/packages-dnf.yaml`.

Runtime versions (node, go, rust) are pinned in `mise/config.toml`.
