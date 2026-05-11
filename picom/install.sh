#!/bin/bash
set -e

cd "$(dirname "$0")"

git submodule update --init --recursive
meson setup --buildtype=release . build
ninja -C build
sudo ninja -C build install

echo "picom installed."