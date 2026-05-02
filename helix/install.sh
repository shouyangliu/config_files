#!/bin/bash
set -e

echo "==> Installing Helix Editor..."

# Try apt first
if sudo apt install -y helix 2>/dev/null; then
    echo "Helix installed via apt"
else
    # Fallback: download from GitHub releases
    echo "Downloading Helix from GitHub..."
    LATEST=$(curl -s https://api.github.com/repos/helix-editor/helix/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
    URL="https://github.com/helix-editor/helix/releases/download/${LATEST}/helix-${LATEST}-x86_64-linux.tar.xz"
    
    curl -Lo /tmp/helix.tar.xz "$URL"
    tar -xf /tmp/helix.tar.xz -C /tmp
    mkdir -p ~/.local/bin
    cp /tmp/helix-*/hx ~/.local/bin/
    rm -rf /tmp/helix*
    
    echo "Helix installed to ~/.local/bin/hx"
fi

echo "==> Installing LSP servers..."

# C/C++ - clangd
sudo apt install -y clangd

# Python - pyright (via pipx)
if ! command -v pyright &> /dev/null; then
    sudo apt install -y pipx
    pipx install pyright
    export PATH="$HOME/.local/bin:$PATH"
fi

# CMake - cmake-language-server (via pipx)
if ! command -v cmake-language-server &> /dev/null; then
    pipx install cmake-language-server
fi

# Rust - rust-analyzer (via rustup or download)
if ! command -v rust-analyzer &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
    rustup component add rust-analyzer
    ln -sf ~/.cargo/bin/rust-analyzer ~/.local/bin/rust-analyzer 2>/dev/null || true
fi

echo "==> Configuring Helix..."

# Create config symlink
mkdir -p ~/.config/helix
[ -L ~/.config/helix/config.toml ] || ln -sf "$(cd "$(dirname "$0")" && pwd)/config.toml" ~/.config/helix/config.toml

echo "==> Helix installation complete!"
