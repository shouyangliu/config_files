#!/bin/bash
set -e

cd "$(dirname "$0")"
[ -L /usr/local/bin/dwm ] && sudo rm /usr/local/bin/dwm
sudo make clean install
sudo ln -sf "$PWD/dwm.desktop" /usr/share/xsessions/dwm.desktop 2>/dev/null || true

echo "dwm installed."