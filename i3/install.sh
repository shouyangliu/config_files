#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config"
TARGET_LINK="$HOME/.config/i3/config"

echo "Installing i3 configuration..."

mkdir -p "$HOME/.config/i3"

if [ -L "$TARGET_LINK" ]; then
    CURRENT=$(readlink -f "$TARGET_LINK")
    if [ "$CURRENT" = "$CONFIG_FILE" ]; then
        echo "Configuration already linked."
    else
        mv "$TARGET_LINK" "$TARGET_LINK.backup.$(date +%Y%m%d%H%M%S)"
        ln -sf "$CONFIG_FILE" "$TARGET_LINK"
    fi
elif [ -f "$TARGET_LINK" ]; then
    mv "$TARGET_LINK" "$TARGET_LINK.backup.$(date +%Y%m%d%H%M%S)"
    ln -sf "$CONFIG_FILE" "$TARGET_LINK"
else
    ln -sf "$CONFIG_FILE" "$TARGET_LINK"
fi

echo "Linked: $TARGET_LINK -> $CONFIG_FILE"
echo "Done! Run 'i3-msg reload' or restart i3."
