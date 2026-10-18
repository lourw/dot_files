#!/usr/bin/env bash
# Runs tests/e2e.sh inside a fresh distro container as a non-root user with
# passwordless sudo, like a real new machine. Must run as root in the container.
#   In CI:   used by .github/workflows/e2e.yaml
#   Locally: tests/run-local.sh ubuntu:24.04
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_USER=tester

. /etc/os-release
case "${ID} ${ID_LIKE:-}" in
  *arch*) pacman -Syu --noconfirm --needed sudo ;;
  *fedora*) dnf install -y sudo ;;
  *debian*|*ubuntu*) apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y sudo ;;
  *) echo "Unsupported distribution: ${ID}" >&2; exit 1 ;;
esac

useradd -m -s /bin/bash "$TEST_USER"
echo "$TEST_USER ALL=(ALL) NOPASSWD: ALL" >"/etc/sudoers.d/$TEST_USER"

# Copy the checkout to where bootstrap.sh would clone it
home="$(getent passwd "$TEST_USER" | cut -d: -f6)"
mkdir -p "$home/.config"
cp -a "$SRC" "$home/.config/dot_files"
chown -R "$TEST_USER:" "$home/.config"

# apt prompts (e.g. tzdata) must not block
sudo -u "$TEST_USER" -H env DEBIAN_FRONTEND=noninteractive \
  bash "$home/.config/dot_files/tests/e2e.sh"
