#!/bin/bash
set -e

[ -d "$HOME/.config/rofi/launchers/type-5" ] || { echo "rofi theme not found"; exit 1; }
cat > "$HOME/.config/rofi/config.rasi" << EOF
@import "$HOME/.config/rofi/launchers/type-5/style-2.rasi"
EOF