#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -L "$HOME/.bashrc" ]; then
    echo "配置文件已存在，跳过链接"
else
    echo "创建 bash 配置链接..."
    ln -sf "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
fi

echo "完成！"