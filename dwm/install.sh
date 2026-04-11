#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "==> Installing dependencies..."
if command -v apt-get &> /dev/null; then
    sudo apt-get install -y libx11-dev libxinerama-dev libfontconfig-dev libxft-dev
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm libx11 libxinerama fontconfig libxft
fi

echo "==> Building dwmblocks..."
cd "$DOTFILES_DIR/dwmblocks"
make clean
make
sudo cp -f dwmblocks /usr/local/bin/
sudo chmod 755 /usr/local/bin/dwmblocks
echo "dwmblocks installed."

echo "==> Building dwm..."
cd "$DOTFILES_DIR/dwm"
make clean
make
sudo make install
sudo cp dwm.desktop /usr/share/xsessions/ 2>/dev/null || true
echo "dwm installed."

echo ""
echo "==> Done! Please restart your X session."