#!/bin/sh

xrdb merge ~/.Xresources 2>/dev/null || true
brightnessctl set 10% &
feh --randomize --bg-fill $HOME/.config/wallpaper/ &
xset r rate 200 50 &
picom --config ~/.picom.conf &
fcitx5 -d &

dash ~/.config/chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
