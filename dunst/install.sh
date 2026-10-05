#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing dunst..."
# dunst        —— 通知守护进程，在 D-Bus 上占住 org.freedesktop.Notifications
# libnotify-bin —— 提供 notify-send，手动发通知测试用
sudo apt install -y dunst libnotify-bin

echo "==> Setting up symlink..."
# dunst 找配置是「命中第一个就停」：~/.config/dunst/dunstrc 优先于
# /etc/xdg/dunst/dunstrc，两者不合并。
mkdir -p ~/.config/dunst
ln -snf "$SCRIPT_DIR/dunstrc" ~/.config/dunst/dunstrc

echo "dunst installed."
echo "  守护进程由 dwm/autostart.sh 启动，注销重登生效"
echo "  （或在当前会话手动跑一次：dunst &）"
