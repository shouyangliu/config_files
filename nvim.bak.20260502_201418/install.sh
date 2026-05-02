#!/bin/bash
set -e

sudo apt install -y ripgrep git
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y neovim

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
[ -L "$HOME/.config/nvim" ] || ln -sf "$SCRIPT_DIR" "$HOME/.config/nvim"