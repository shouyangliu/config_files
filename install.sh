#!/bin/bash

sudo apt install -y fcitx fcitx-googlepinyin make cmake libx11-dev libxft-dev libxinerama-dev
./ln.sh
cd ./dwm/ && sudo make clean install
cd ../st_own/ && sudo make clean install
cd ../dwmblocks/ && sudo make clean install
cd ../nvim/ && ./install.sh
cd ../rofi/ && ./setup.sh
sudo cp -r ./nerdfont/ComicShannsMono/ /usr/share/fonts/
fc-cache -fv
sudo apt install libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev meson
git clone https://github.com/yaocccc/picom.git
cd picom
git submodule update --init --recursive
meson --buildtype=release . bulde
ninja -C build
sudo ninja -C build install

sudo cp ./dwm.desktop /usr/share/xsessions/
sudo apt install -y rofi
./rofi_theme/setup.sh
sudo apt install -y feh polybar
