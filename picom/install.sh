#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if command -v picom &>/dev/null; then
    echo "picom already installed: $(picom --version 2>&1)"
    exit 0
fi

echo "Installing build dependencies..."

# 基础依赖
DEPS=(
    libx11-dev libx11-xcb-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev
    libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev
    libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-glx0-dev
    libxcb-dpms0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev
    libpcre2-dev libev-dev libepoxy-dev uthash-dev meson ninja-build
)

# 逐个安装，跳过不存在的包
for dep in "${DEPS[@]}"; do
    sudo apt install -y "$dep" 2>/dev/null || echo "Warning: $dep not found, skipping..."
done

# xcb-util 可能叫不同名字
sudo apt install -y libxcb-util-dev 2>/dev/null || \
sudo apt install -y libxcb-util0-dev 2>/dev/null || \
echo "Warning: libxcb-util not found, skipping..."

echo "Building picom..."
cd "$SCRIPT_DIR/source"
rm -rf build
meson setup --buildtype=release --prefix=/usr/local build
ninja -C build

echo "Installing picom..."
sudo ninja -C build install

echo "picom installed: $(picom --version 2>&1)"
