# Dotfiles Repo Improvement Notes

Remaining suggestions (last reviewed 2026-10-18).

1. **No CI** — a GitHub Action running `ansible-lint`, `shellcheck bootstrap.sh` and a
   playbook syntax check on every push (optionally a Fedora/Arch container running
   `bootstrap.sh` end to end) would catch mistakes before they hit a new machine.

2. **tmux terminal** — consider `default-terminal "tmux-256color"` on Linux for better
   truecolor in nvim.
