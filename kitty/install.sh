#!/bin/bash

echo "安装 Kitty..."

if command -v kitty &> /dev/null; then
    echo "Kitty 已安装: $(kitty --version)"
else
    sudo apt install -y kitty
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p ~/.config/kitty
ln -sf "$SCRIPT_DIR/kitty.conf" ~/.config/kitty/kitty.conf

echo "完成！"
