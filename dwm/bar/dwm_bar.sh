#!/bin/bash

black="#1a1b26"
grey="#414868"
blue="#7aa2f7"
green="#9ece6a"
red="#f7768e"
yellow="#e0af68"
purple="#bb9af7"

dwm_date () {
    printf "^b$blue^ 󰥔 %s" "$(date +"%H:%M")"
}

dwm_battery () {
    CHARGE=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null)
    STATUS=$(cat /sys/class/power_supply/BAT1/status 2>/dev/null)
    if [ -z "$CHARGE" ]; then
        printf "^b$grey^ 󰁹 --"
        return
    fi
    if [ "$STATUS" = "Charging" ]; then
        printf "^b$green^ 󰂄 %s%%" "$CHARGE"
    elif [ "$CHARGE" -le 20 ]; then
        printf "^b$red^ 󰁺 %s%%" "$CHARGE"
    else
        printf "^b$yellow^ 󰁹 %s%%" "$CHARGE"
    fi
}

dwm_cpu(){
    read cpu a b c previdle rest < /proc/stat
    prevtotal=$((a+b+c+previdle))
    sleep 0.5
    read cpu a b c idle rest < /proc/stat
    total=$((a+b+c+idle))
    cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
    if [ "$cpu" -lt 0 ]; then
        cpu=0
    fi
    printf "^b$purple^ 󰧨 %d%%" "$cpu"
}

print_mem(){
    memfree=$(($(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') / 1024))
    memtotal=$(($(grep -m1 'MemTotal:' /proc/meminfo | awk '{print $2}') / 1024 ))
    memused=$((memtotal - memfree))
    printf "^b$blue^ 󰍛 %dM" "$memused"
}

while true
do
    xsetroot -name "$(print_mem)$(dwm_cpu)$(dwm_battery)$(dwm_date)"
    sleep 2
done

