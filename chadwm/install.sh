#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="$HOME/.local/bin:$PATH"

echo "==> Installing chadwm dependencies..."
sudo apt-get install -y libimlib2-dev libgtk-3-dev

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
chmod +x "$SCRIPT_DIR"/scripts/* "$SCRIPT_DIR"/eww/scripts/*

echo "==> Registering session..."
sudo ln -sf "$SCRIPT_DIR/chadwm.desktop" /usr/share/xsessions/chadwm.desktop 2>/dev/null || \
    echo "Warning: could not write /usr/share/xsessions/chadwm.desktop, register it manually."

# eww is optional: the WM and its status bar work without it (only Super+E needs it).
# Kept last and non-fatal so a failed Rust build cannot leave the setup half-applied.
echo "==> Building eww (optional, may take several minutes)..."
if command -v eww >/dev/null 2>&1; then
    echo "    eww already installed, skipping."
elif cargo install --locked --no-default-features --features x11 \
        --git https://github.com/elkowar/eww --tag v0.6.0; then
    echo "    eww installed."
else
    echo "    Warning: eww build failed. It needs a newer Rust than $(rustc --version 2>/dev/null | awk '{print $2}')."
    echo "    Try: rustup update stable   (then re-run this script)"
    echo "    chadwm itself is installed and usable; Super+E will not work until eww is built."
fi

echo "chadwm installed."
