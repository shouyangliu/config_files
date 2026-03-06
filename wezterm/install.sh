#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "安装 WezTerm..."

if command -v wezterm &> /dev/null; then
    echo "WezTerm 已安装: $(wezterm --version 2>/dev/null)"
else
    echo "尝试通过 APT 仓库安装..."
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg 2>/dev/null
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list > /dev/null
    sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
    
    if sudo apt update && sudo apt install -y wezterm; then
        echo "WezTerm 安装成功"
    else
        echo "APT 安装失败，尝试使用 AppImage..."
        APPIMAGE_URL="https://github.com/wez/wezterm/releases/download/latest/WezTerm-x86_64.AppImage"
        mkdir -p "$HOME/.local/bin"
        curl -fsSL "$APPIMAGE_URL" -o "$HOME/.local/bin/wezterm"
        chmod +x "$HOME/.local/bin/wezterm"
        echo "AppImage 已下载到 ~/.local/bin/wezterm"
    fi
fi

if command -v wezterm &> /dev/null; then
    echo "WezTerm: $(wezterm --version 2>/dev/null)"
else
    echo "警告: WezTerm 安装可能未成功"
fi

echo "配置 WezTerm..."
mkdir -p ~/.config/wezterm
ln -sf "$SCRIPT_DIR/wezterm.lua" ~/.config/wezterm/wezterm.lua

echo "完成！"