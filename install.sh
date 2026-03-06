#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo cp -r "$SCRIPT_DIR/nerdfont/ComicShannsMono/" /usr/share/fonts/
fc-cache -fv

cd "$SCRIPT_DIR/fcitx" && ./install.sh
cd "$SCRIPT_DIR/picom" && ./install.sh
cd "$SCRIPT_DIR/dwm" && sudo make clean install
sudo cp "$SCRIPT_DIR/dwm.desktop" /usr/share/xsessions/
cd "$SCRIPT_DIR/wezterm" && ./install.sh
cd "$SCRIPT_DIR/kitty" && ./install.sh
cd "$SCRIPT_DIR/st" && sudo make clean install
cd "$SCRIPT_DIR/dwmblocks" && sudo make clean install
cd "$SCRIPT_DIR/nvim" && ./install.sh
sudo apt install -y rofi
cd "$SCRIPT_DIR/rofi_theme" && ./install.sh
sudo apt install -y libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev meson

sudo apt install -y feh polybar
cd "$SCRIPT_DIR/polybar" && ./install.sh

cd "$SCRIPT_DIR/tmux" && ./install.sh
