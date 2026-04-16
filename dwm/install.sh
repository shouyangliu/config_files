#!/bin/bash
set -e

cd "$(dirname "$0")"
make clean
make

# Remove old binary if exists and is not busy
rm -f /usr/local/bin/dwm 2>/dev/null || true

# Use symlink
sudo ln -sf "$PWD/dwm" /usr/local/bin/dwm
sudo ln -sf "$PWD/dwm.desktop" /usr/share/xsessions/dwm.desktop 2>/dev/null || true

echo "dwm installed."