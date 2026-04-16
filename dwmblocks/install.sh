#!/bin/bash
set -e

cd "$(dirname "$0")"
make clean
make
sudo cp -f dwmblocks /usr/local/bin/
sudo chmod 755 /usr/local/bin/dwmblocks