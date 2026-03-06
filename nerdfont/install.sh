#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "安装 Nerd Fonts..."

if [ -d "$SCRIPT_DIR/ComicShannsMono" ]; then
    sudo cp -r "$SCRIPT_DIR/ComicShannsMono" /usr/share/fonts/
    fc-cache -fv
    echo "Nerd Fonts 已安装"
else
    echo "字体目录不存在"
    exit 1
fi