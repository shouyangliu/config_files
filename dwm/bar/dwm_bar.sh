#!/bin/bash

black="#1a1b26"
grey="#414868"
blue="#7aa2f7"
green="#9ece6a"
red="#f7768e"
yellow="#e0af68"
purple="#bb9af7"
cyan="#7dcfff"
orange="#ff9e64"
pink="#bb9af7"

dwm_wifi() {
    ssid=$(iwgetid -r 2>/dev/null)
    if [ -z "$ssid" ]; then
        printf "^c$grey^^b$grey^ 睊 --"
    else
        signal=$(cat /proc/net/wireless 2>/dev/null | awk 'NR==3 {print int($3)}')
        if [ -z "$signal" ]; then
            printf "^c$cyan^^b$blue^ 󰤨 %s" "$ssid"
        else
            printf "^c$black^^b$cyan^ 󰤨 %s" "$ssid"
        fi
    fi
}

dwm_date() {
    printf "  ^c$black^^b$orange^%s " "$(date +"%Y-%m-%d %H:%M")"
}

dwm_battery() {
    BAT=$(ls /sys/class/power_supply/BAT* 2>/dev/null | head -1)
    CHARGE=$(cat "$BAT/capacity" 2>/dev/null)
    STATUS=$(cat "$BAT/status" 2>/dev/null)
    if [ -z "$CHARGE" ]; then
        printf "^c$grey^^b$grey^ --"
        return
    fi
    if [ "$STATUS" = "Charging" ]; then
        printf "^c$black^^b$green^ 󰂄 %s%%" "$CHARGE"
    elif [ "$CHARGE" -le 20 ]; then
        printf "^c$black^^b$red^ 󰁺 %s%%" "$CHARGE"
    else
        printf "^c$black^^b$cyan^ 󰁽 %s%%" "$CHARGE"
    fi
}

dwm_cpu() {
    read cpu a b c previdle rest < /proc/stat
    prevtotal=$((a+b+c+previdle))
    sleep 0.5
    read cpu a b c idle rest < /proc/stat
    total=$((a+b+c+idle))
    cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
    if [ "$cpu" -lt 0 ]; then
        cpu=0
    fi
    printf "^c$black^^b$purple^ CPU: %d%%" "$cpu"
}

dwm_mem() {
    memfree=$(($(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') / 1024))
    memtotal=$(($(grep -m1 'MemTotal:' /proc/meminfo | awk '{print $2}') / 1024))
    memused=$((memtotal - memfree))
    mempercent=$((memused * 100 / memtotal))
    printf "^c$black^^b$green^ MEM: %dM %d%%" "$memused" "$mempercent"
}

dwm_ip() {
    ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    if [ -z "$ip" ]; then
        printf "^c$grey^^b$grey^ --"
    else
        printf "^c$black^^b$yellow^ 󰈟 %s" "$ip"
    fi
}

dwm_separator() {
    printf " "
}

dwm_emoji() {
    printf "^c$black^^b$yellow^  "
}

while true; do
    xsetroot -name "$(dwm_wifi)$(dwm_separator)$(dwm_ip)$(dwm_separator)$(dwm_mem)$(dwm_separator)$(dwm_cpu)$(dwm_separator)$(dwm_battery)$(dwm_separator)$(dwm_date)$(dwm_emoji)"
    sleep 2
done