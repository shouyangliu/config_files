#!/bin/bash
set -e

mkdir -p ~/.config/rofi
ln -snf "$(cd "$(dirname "$0")" && pwd)/files/colors" ~/.config/rofi/colors
ln -snf "$(cd "$(dirname "$0")" && pwd)/files/launchers" ~/.config/rofi/launchers
ln -snf "$(cd "$(dirname "$0")" && pwd)/files/scripts" ~/.config/rofi/scripts
ln -snf "$(cd "$(dirname "$0")" && pwd)/files/images" ~/.config/rofi/images
ln -snf "$(cd "$(dirname "$0")" && pwd)/files/applets" ~/.config/rofi/applets
ln -snf "$(cd "$(dirname "$0")" && pwd)/files/powermenu" ~/.config/rofi/powermenu

cat > ~/.config/rofi/config.rasi << EOF
@theme "~/.config/rofi/launchers/type-5/style-2"
configuration {
    show-icons: true;
}
EOF

echo "rofi theme installed."