#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PICOM_BIN="/usr/local/bin/picom"

if command -v picom &>/dev/null; then
    echo "picom already installed: $(picom --version 2>&1)"
    exit 0
fi

echo "Installing build dependencies..."

# 根据系统版本安装依赖，兼容 20.04 / 22.04 / 24.04+
install_deps() {
    sudo apt install -y \
        libx11-dev libx11-xcb-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev \
        libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev \
        libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-glx0-dev \
        libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev \
        libev-dev libepoxy-dev uthash-dev meson ninja-build 2>/dev/null && return 0

    # 20.04 需要额外的包名
    sudo apt install -y \
        libxcb-dpms0-dev libxcb-util-dev 2>/dev/null && return 0

    # 22.04+ 的包名
    sudo apt install -y \
        libxcb-dpms-dev libxcb-util-dev 2>/dev/null && return 0
}

install_deps

echo "Building picom..."
cd "$SCRIPT_DIR/source"
meson setup --buildtype=release --prefix=/usr/local build
ninja -C build

echo "Installing picom..."
sudo ninja -C build install

echo "picom installed: $(picom --version 2>&1)"
