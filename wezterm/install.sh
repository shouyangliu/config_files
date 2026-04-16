#!/bin/bash
set -e

if ! command -v wezterm &> /dev/null; then
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
    sudo apt update && sudo apt install -y wezterm
fi

mkdir -p ~/.config
ln -sf "$(cd "$(dirname "$0")" && pwd)/wezterm.lua" ~/.config/wezterm/wezterm.lua