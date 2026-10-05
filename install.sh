#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="$HOME/.local/bin:$PATH"

echo "==> Setting up symlinks..."
mkdir -p ~/.config
ln -snf "$SCRIPT_DIR/nvim" ~/.config/nvim
ln -snf "$SCRIPT_DIR/tmux/.tmux.conf" ~/.tmux.conf
ln -snf "$SCRIPT_DIR/picom/picom.conf" ~/.picom.conf
mkdir -p ~/.config/wezterm
rm -f ~/.config/wezterm/wezterm.lua
ln -snf "$SCRIPT_DIR/wezterm/wezterm.lua" ~/.config/wezterm/wezterm.lua
ln -snf "$SCRIPT_DIR/wallpaper" ~/.config/wallpaper
ln -snf "$SCRIPT_DIR/rofi_theme" ~/.config/rofi

echo "==> Installing dependencies..."
# Fix security repo to use TUNA mirror if needed
grep -q 'mirrors.tuna.tsinghua.edu.cn/ubuntu.*jammy-security' /etc/apt/sources.list || \
  sudo sed -i 's|http://security.ubuntu.com/ubuntu|http://mirrors.tuna.tsinghua.edu.cn/ubuntu|g' /etc/apt/sources.list

# Add missing wezterm GPG key
curl -fsSL https://wezterm.org/wezterm.gpg | sudo gpg --no-default-keyring --keyring /usr/share/keyrings/wezterm.gpg --import --batch 2>/dev/null || true
sudo apt update || echo "Warning: apt update encountered errors, continuing..."
# 下面这批 -dev 包是给 picom/install.sh 从源码 meson 编译用的
# （对齐 picom/src/meson.build 的 required_packages / required_xcb_packages）。
# dwm / dwl 删掉后，libxft-dev libfontconfig-dev libxinerama-dev libxkbcommon-dev
# libinput-dev libwlroots-dev libwayland-dev wayland-protocols 已经没人用了
# （已逐个确认没有任何已装包依赖它们）；eww 没用上，cargo 也一并去掉。
# wireless-tools（iwconfig）也删了 —— 状态栏读的是 /sys/class/net/wl*/operstate，
# 原来的 bar.sh 里也没用过 iwconfig；它是 ubuntu-desktop 的依赖，真需要也还在。
#
# libpcre3-dev 看着像老古董，但**不能删**：picom 走的是 pcre1
# （meson 里 dependency('libpcre')，编出来的二进制链的是 libpcre.so.3）。
sudo apt install -y \
    libx11-dev libxext-dev libxcb1-dev libx11-xcb-dev libpixman-1-dev \
    libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev \
    libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev \
    libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev \
    libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre3-dev \
    uthash-dev libev-dev \
    meson rofi feh ripgrep git curl xdotool flameshot

echo "==> Running module installs..."
run_module() {
    local module=$1
    local dir="$SCRIPT_DIR/$module"
    if [ -f "$dir/install.sh" ]; then
        echo "===> Installing $module..."
        (cd "$dir" && ./install.sh)
    fi
}

run_module fcitx
run_module picom
run_module awesome
run_module wezterm
run_module bash
run_module rofi_theme
run_module tmux
run_module nvim
run_module nerdfont

echo ""
echo "==> All done!"