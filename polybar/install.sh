#!/bin/bash

echo "==> Installing polybar..."

# Check if polybar is already installed
if command -v polybar &> /dev/null; then
    echo "polybar already installed"
else
    echo "polybar not found, you may need to build from source"
    echo "See: https://github.com/polybar/polybar"
fi

# Make scripts executable
chmod +x "$HOME/.config/polybar/scripts/"*.sh 2>/dev/null || true

echo "==> Polybar setup complete"