#!/bin/bash
set -e

cd "$(dirname "$0")"

# 安装依赖
if command -v apt &> /dev/null; then
    sudo apt update
    sudo apt install -y gcc make libx11-dev libxinerama-dev feh
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm libx11 libxinerama feh
elif command -v dnf &> /dev/null; then
    sudo dnf install -y libX11-devel libXinerama-devel feh
fi

# 安装 dwm
[ -L /usr/local/bin/dwm ] && sudo rm /usr/local/bin/dwm
sudo make clean install
sudo ln -sf "$PWD/dwm.desktop" /usr/share/xsessions/dwm.desktop 2>/dev/null || true

echo "dwm installed."