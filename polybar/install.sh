#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR/polybar-themes-master"
sudo chmod +x setup.sh
./setup.sh
