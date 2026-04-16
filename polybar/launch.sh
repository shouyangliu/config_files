#!/bin/bash

killall -q polybar

while pgrep -x polybar > /dev/null; do sleep 1; done

CONFIG=~/.config/polybar/config.ini

if [ -f "$CONFIG" ]; then
    polybar main -c "$CONFIG" &
else
    polybar main &
fi