#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
[ -L "$HOME/.bashrc" ] || ln -sf "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"