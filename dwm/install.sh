#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "编译安装 dwm..."

cd "$DOTFILES_DIR/dwm"

if [ ! -f config.h ]; then
    echo "config.h 不存在"
    exit 1
fi

sudo make clean 2>/dev/null || true

if sudo make; then
    sudo make install
    sudo cp dwm.desktop /usr/share/xsessions/ 2>/dev/null || true
    echo "dwm 编译安装成功"
else
    echo "dwm 编译失败"
    exit 1
fi
