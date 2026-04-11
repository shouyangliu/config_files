#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/kitty.conf"
TARGET_LINK="$HOME/.config/kitty/kitty.conf"

echo "Installing Kitty configuration..."

if ! command -v kitty &> /dev/null; then
    echo "Installing Kitty terminal..."
    sudo apt update && sudo apt install -y kitty
fi

mkdir -p "$HOME/.config/kitty"

if [ -L "$TARGET_LINK" ]; then
    CURRENT=$(readlink -f "$TARGET_LINK")
    if [ "$CURRENT" = "$CONFIG_FILE" ]; then
        echo "Configuration already linked: $TARGET_LINK -> $CONFIG_FILE"
    else
        echo "Backing up existing symlink: $TARGET_LINK -> $CURRENT"
        mv "$TARGET_LINK" "$TARGET_LINK.backup.$(date +%Y%m%d%H%M%S)"
        ln -sf "$CONFIG_FILE" "$TARGET_LINK"
        echo "Linked: $TARGET_LINK -> $CONFIG_FILE"
    fi
elif [ -f "$TARGET_LINK" ]; then
    echo "Backing up existing config: $TARGET_LINK"
    mv "$TARGET_LINK" "$TARGET_LINK.backup.$(date +%Y%m%d%H%M%S)"
    ln -sf "$CONFIG_FILE" "$TARGET_LINK"
    echo "Linked: $TARGET_LINK -> $CONFIG_FILE"
else
    ln -sf "$CONFIG_FILE" "$TARGET_LINK"
    echo "Linked: $TARGET_LINK -> $CONFIG_FILE"
fi

echo ""
echo "Done! Restart Kitty or press Ctrl+Shift+R to reload config."
