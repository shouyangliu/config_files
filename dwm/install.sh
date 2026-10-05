#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing packages for keybindings..."
# config.h 里新增的那几个键会 fork 外部命令，这些包本机碰巧有、但原来**不在任何
# install.sh 里**（pulseaudio-utils 大概是桌面环境捎带装的），换机器就是哑键。
# slock     —— Super+Escape 直接调它
# xss-lock  —— autostart.sh 里挂着，负责"合盖/挂起前自动锁"和空闲超时锁；
#              单靠手动按键做不到这两件事
# brightnessctl   —— XF86 亮度键（装包时带了 udev 规则，普通用户就能写，不用 sudo）
# pulseaudio-utils —— 提供 pactl，XF86 音量/静音键
sudo apt install -y slock xss-lock brightnessctl pulseaudio-utils

echo "==> Building dwm..."
# config.h / config.mk 是**编译进二进制**的：改过就必须重跑这个脚本，
# 否则跑的还是旧配置（这是 dwm 系最烦的一点，也是当初想换掉它的原因）。
cd "$SCRIPT_DIR"
# 早先的装法是把二进制软链过去，先删掉，让 make install 放一份真文件进 /usr/local/bin
[ -L /usr/local/bin/dwm ] && sudo rm /usr/local/bin/dwm
sudo make clean install

echo "==> Setting up symlinks..."
mkdir -p ~/.config
# ~/.config/dwm 可能是真目录也可能是软链，两种都清掉再建
rm -rf ~/.config/dwm
ln -snf "$SCRIPT_DIR" ~/.config/dwm
# .Xresources 由 Xsession 在登录时自动 xrdb -merge（30x11-common_xresources）
ln -snf "$SCRIPT_DIR/.Xresources" ~/.Xresources

# 自启脚本。**dwm 的 autostart patch 不看 ~/.config/dwm** —— 见 dwm/dwm.c 的
# runautostart()，它按这个顺序找 autostart.sh：
#   $XDG_DATA_HOME/dwm  →  ~/.local/share/dwm  →  ~/.dwm
# 下面建的是第二个。漏掉这条，新机器上 picom / 状态栏都不会起来
# （本机那个是手工建的，原来这脚本里根本没有）。
mkdir -p ~/.local/share/dwm
ln -snf "$SCRIPT_DIR/autostart.sh" ~/.local/share/dwm/autostart.sh
chmod +x "$SCRIPT_DIR/autostart.sh"

echo "==> Installing session file..."
sudo ln -sf "$SCRIPT_DIR/dwm.desktop" /usr/share/xsessions/dwm.desktop 2>/dev/null || true

# ---------------------------------------------------------------------------
# 清掉上一个窗口管理器（awesome）留下的东西。刻意放在最后：上面任何一步失败时，
# 当前会话都还是完整的，不会卡在「没有可用窗口管理器」的状态。
# ---------------------------------------------------------------------------
echo "==> Removing previous WM (awesome)..."
sudo rm -f /usr/share/xsessions/awesome.desktop
rm -rf ~/.config/awesome

echo "dwm installed."
echo "  注销后在登录界面选 dwm 即可"
