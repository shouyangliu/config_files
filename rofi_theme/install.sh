#!/bin/bash

echo "正在检查 Rofi 是否已安装..."
if ! command -v rofi &> /dev/null; then
    echo "Rofi 未安装，请先安装：sudo apt install rofi"
    exit 1
fi

CONFIG_DIR="$HOME/.config/rofi"
THEME_DIR="$HOME/.config/rofi/launchers/type-5"

mkdir -p "$CONFIG_DIR"

if [ -f "$THEME_DIR/style-1.rasi" ]; then
    cat > "$CONFIG_DIR/config.rasi" << EOF
@import "$THEME_DIR/style-2.rasi"
EOF
    echo "已安装 Nitro 主题！"
else
    echo "错误：未找到 Nitro 主题文件"
    exit 1
fi

echo "=================================="
echo " 主题安装完成！"
echo " 测试命令：rofi -show drun"
echo "=================================="
