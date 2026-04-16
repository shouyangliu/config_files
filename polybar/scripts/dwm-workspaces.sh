#!/bin/bash

# Get current dwm workspace
# Since dwm doesn't set _NET_CURRENT_DESKTOP by default,
# we'll try to detect via active window

# Get active window
WIN=$(xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | grep -o '0x[0-9a-f]*' | tail -1)

if [ -n "$WIN" ]; then
    # Try to get desktop of focused window
    DESK=$(xprop -id "$WIN" _NET_WM_DESKTOP 2>/dev/null | grep -oP '\(\K[0-9]+' || echo "0")
else
    DESK="0"
fi

# Convert to 1-based
WS=$((DESK + 1))

echo "%{F#1a1b26}%{B#7aa2f7} $WS %{F-}%{B-}"