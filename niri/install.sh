#!/bin/bash
set -e

echo "Installing niri..."

sudo apt-get update

sudo apt-get install -y \
    cargo \
    pkg-config \
    liblzma-dev \
    libzstd-dev \
    libudev-dev \
    libgbm-dev \
    libdrm-dev \
    libseat-dev \
    scdoc \
    libxkbcommon-dev \
    libpixman-1-dev \
    libegl-dev \
    libinput-dev \
    libwayland-dev \
    wayland-protocols \
    libfontconfig-dev \
    libfreetype-dev \
    libpng-dev \
    libxcb-xfixes0-dev \
    libdisplay-info-dev

if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

if ! command -v niri &> /dev/null; then
    cargo install --git https://github.com/YaLTeR/niri --locked niri --features static
fi

mkdir -p ~/.config/niri
cp niri-config.kdl ~/.config/niri/config.kdl

# Disable spawn-at-startup to avoid session crash
sed -i 's/^spawn-at-startup/# spawn-at-startup/' ~/.config/niri/config.kdl

mkdir -p ~/.config/waybar
if [ -f waybar-config ]; then
    cp waybar-config ~/.config/waybar/config
fi
if [ -f waybar-style.css ]; then
    cp waybar-style.css ~/.config/waybar/style.css
fi

sudo apt-get install -y waybar dunst udiskie network-manager-gnome wofi 2>/dev/null || true

if [ ! -f /usr/share/wayland-sessions/niri.desktop ]; then
    sudo tee /usr/share/wayland-sessions/niri.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=niri
Comment=niri session
Exec=niri
Type=Application
EOF
fi

echo "Done! Reboot and select niri."
