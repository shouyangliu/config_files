#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "编译安装 dwmblocks..."

cd "$DOTFILES_DIR/dwmblocks"

sudo make clean 2>/dev/null || true

if sudo make; then
    sudo make install
    echo "dwmblocks 编译安装成功"
else
    echo "dwmblocks 编译失败"
    exit 1
fi
