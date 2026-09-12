#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 检查 Ubuntu 版本，只支持 24.04+
if ! grep -qiE "ubuntu" /etc/os-release 2>/dev/null; then
    echo "Error: This script only supports Ubuntu."
    exit 1
fi

VERSION=$(grep VERSION_ID /etc/os-release | cut -d'"' -f2)
if [ "$(echo "$VERSION < 24.04" | bc)" -eq 1 ]; then
    echo "Error: Ubuntu $VERSION is not supported. Requires 24.04+."
    exit 1
fi

if command -v picom &>/dev/null; then
    echo "picom already installed: $(picom --version 2>&1)"
    exit 0
fi

echo "Installing build dependencies on Ubuntu $VERSION..."
sudo apt install -y \
    libx11-dev libx11-xcb-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev \
    libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev \
    libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-glx0-dev \
    libxcb-dpms0-dev libxcb-util-dev \
    libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev \
    libev-dev libepoxy-dev uthash-dev meson ninja-build

echo "Building picom..."
cd "$SCRIPT_DIR/source"
rm -rf build
meson setup --buildtype=release --prefix=/usr/local build
ninja -C build

echo "Installing picom..."
sudo ninja -C build install

echo "picom installed: $(picom --version 2>&1)"
