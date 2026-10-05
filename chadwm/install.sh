#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="$HOME/.local/bin:$PATH"

echo "==> Installing chadwm dependencies..."
# x11-xserver-utils 提供 xsetroot（bar.sh 用它把状态文字塞给 dwm）和 xset（run.sh 调键盘速率）
# psmisc 提供 killall（config.h 里重载状态栏的绑定用）
# brightnessctl 被 run.sh 和 config.h 的亮度键使用（上游用的是未打包的 light）
sudo apt-get install -y libimlib2-dev libgtk-3-dev brightnessctl x11-xserver-utils psmisc

echo "==> Removing old dwm (replaced by chadwm)..."
sudo rm -f /usr/local/bin/dwm /usr/share/xsessions/dwm.desktop 2>/dev/null || true
rm -f ~/.config/dwm ~/.local/share/dwm/autostart.sh
rmdir ~/.local/share/dwm 2>/dev/null || true

echo "==> Building chadwm..."
# NOTE: deliberately NOT `make clean` -- its recipe does `rm -f config.h`, and the
# config.h rule is `cp config.def.h $@`, so cleaning would silently reset the local
# config. Plain `make` already rebuilds because ${OBJ} depends on config.h.
cd "$SCRIPT_DIR/chadwm"
make
sudo make install   # installs as /usr/local/bin/chadwm (see Makefile), does not clash with dwm

echo "==> Setting up symlinks..."
rm -rf ~/.config/chadwm
ln -snf "$SCRIPT_DIR" ~/.config/chadwm
ln -snf "$SCRIPT_DIR/.Xresources" ~/.Xresources
chmod +x "$SCRIPT_DIR"/scripts/*

echo "==> Registering session..."
sudo ln -sf "$SCRIPT_DIR/chadwm.desktop" /usr/share/xsessions/chadwm.desktop 2>/dev/null || \
    echo "Warning: could not write /usr/share/xsessions/chadwm.desktop, register it manually."

# 不装 eww：上游 6 个 release 全部没有预编译产物，Ubuntu 源里也没有，
# 唯一能从源码编译（cargo install --git https://github.com/elkowar/eww）。
# 注意 crates.io 上那个同名的 `eww` 是另一个项目（egui backend），不要用。
# WM 和状态栏都不依赖它，只是状态栏上那个 eww 图标点了没反应
# （注意 Super+E 是 hidewin，跟 eww 无关）；eww/ 目录保留在仓库里，
# 想启用时自行编译即可。

echo "chadwm installed."
