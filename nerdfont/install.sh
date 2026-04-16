#!/bin/bash
set -e

FONT_DIR="$(dirname "$0")/ComicShannsMono"
[ -d "$FONT_DIR" ] && sudo cp -r "$FONT_DIR" /usr/share/fonts/ && fc-cache -fv