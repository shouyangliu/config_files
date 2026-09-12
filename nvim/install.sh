#!/bin/bash
set -e

sudo apt install -y ripgrep git curl

# 直接从 GitHub 下载最新稳定版，兼容所有 Ubuntu 版本
NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
echo "Installing Neovim $NVIM_VERSION..."

curl -LO "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
sudo tar -C /usr/local -xzf nvim-linux-x86_64.tar.gz --strip-components=1
rm -f nvim-linux-x86_64.tar.gz

echo "Neovim installed: $(nvim --version | head -1)"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
[ -L "$HOME/.config/nvim" ] || ln -sf "$SCRIPT_DIR" "$HOME/.config/nvim"