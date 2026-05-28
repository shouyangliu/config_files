#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
[ -L "$HOME/.bashrc" ] || ln -sf "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"

# Install eza if not present
if ! command -v eza &>/dev/null; then
    echo "===> Installing eza binary..."
    EZA_VERSION="0.20.18"
    GH_PROXY="https://ghproxy.net"
    curl -fsSL "${GH_PROXY}/https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_x86_64-unknown-linux-gnu.tar.gz" \
      | sudo tar -xz -C /usr/local/bin
fi