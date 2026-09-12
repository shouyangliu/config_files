#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="$HOME/.local/bin:$PATH"

echo "==> Setting up symlinks..."
mkdir -p ~/.config
mkdir -p ~/.local/share/dwm
ln -snf "$SCRIPT_DIR/nvim" ~/.config/nvim
ln -snf "$SCRIPT_DIR/tmux/.tmux.conf" ~/.tmux.conf
ln -snf "$SCRIPT_DIR/picom/picom.conf" ~/.picom.conf
mkdir -p ~/.config/wezterm
rm -f ~/.config/wezterm/wezterm.lua
ln -snf "$SCRIPT_DIR/wezterm/wezterm.lua" ~/.config/wezterm/wezterm.lua
ln -snf "$SCRIPT_DIR/wallpaper" ~/.config/wallpaper
ln -snf "$SCRIPT_DIR/rofi_theme" ~/.config/rofi
rm -rf ~/.config/dwm
ln -snf "$SCRIPT_DIR/dwm" ~/.config/dwm
ln -snf "$SCRIPT_DIR/dwm/autostart.sh" ~/.local/share/dwm/autostart.sh
chmod +x "$SCRIPT_DIR/dwm/autostart.sh"
chmod +x "$SCRIPT_DIR/dwm/bar/dwm_bar.sh"

echo "==> Installing dependencies..."

# 临时禁用 ROS 源，避免 apt install 拉入不需要的 ROS 包
ROS_DISABLED=false
for f in /etc/apt/sources.list.d/ros-*.sources /etc/apt/sources.list.d/ros-*.list; do
    [ -f "$f" ] || continue
    if [[ "$f" != *.disabled ]]; then
        sudo mv "$f" "${f}.disabled"
        ROS_DISABLED=true
        echo "==> Temporarily disabled ROS source: $f"
    fi
done
trap 'if $ROS_DISABLED; then for f in /etc/apt/sources.list.d/ros-*.sources.disabled /etc/apt/sources.list.d/ros-*.list.disabled; do [ -f "$f" ] && sudo mv "$f" "${f%.disabled}"; done; fi' EXIT

# Fix security repo to use TUNA mirror if needed
if ! grep -q 'mirrors.tuna.tsinghua.edu.cn/ubuntu.*jammy-security' /etc/apt/sources.list; then
  echo "==> Backing up /etc/apt/sources.list..."
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%Y%m%d%H%M%S)
  sudo sed -i 's|http://security.ubuntu.com/ubuntu|http://mirrors.tuna.tsinghua.edu.cn/ubuntu|g' /etc/apt/sources.list
fi

sudo apt update || echo "Warning: apt update encountered errors, continuing..."
sudo apt install -y \
    libx11-dev libxinerama-dev libfontconfig-dev libxft-dev libxext-dev libxcb1-dev \
    libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev \
    libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev \
    libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev \
    libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev \
    uthash-dev libev-dev libx11-xcb-dev meson rofi feh ripgrep git curl cargo xdotool \
    flameshot wireless-tools

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
run_module dwm
run_module wezterm
run_module bash
run_module rofi_theme
run_module tmux
run_module nvim
run_module nerdfont

echo ""
echo "==> All done!"