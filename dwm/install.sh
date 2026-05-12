#!/bin/bash
set -e

cd "$(dirname "$0")"
sudo make clean install
sudo ln -sf "$PWD/dwm.desktop" /usr/share/xsessions/dwm.desktop 2>/dev/null || true

echo "dwm installed."