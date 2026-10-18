#!/usr/bin/env bash
# Run the e2e test in a local container, e.g.: tests/run-local.sh debian:trixie
set -euo pipefail

IMAGE="${1:?usage: run-local.sh <image> (ubuntu:24.04, debian:trixie, fedora:latest, archlinux:latest)}"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENGINE="$(command -v podman || command -v docker)" || { echo "Needs podman or docker" >&2; exit 1; }

"$ENGINE" run --rm -v "$DOTFILES_DIR:/src:ro" "docker.io/library/$IMAGE" bash /src/tests/container.sh
