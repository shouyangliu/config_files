#!/bin/dash

# Available themes: catppuccin, tokyonight, gruvchad, nord, onedark
THEME="catppuccin"

. "$(dirname "$0")/themes/$THEME"

BAT=$(ls /sys/class/power_supply/BAT* 2>/dev/null | head -1)
prev_total=0
prev_idle=0

dwm_wifi() {
    if [ "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" = "up" ]; then
        ssid=$(iwgetid -r 2>/dev/null || iw dev 2>/dev/null | awk '/ssid/{print $2; exit}')
        printf "^c$black^^b$blue^ 󰤨 %s" "$ssid"
    else
        printf "^c$grey^^b$grey^ 󰤭 --"
    fi
}

dwm_date() {
    printf "  ^c$black^^b$orange^%s " "$(date +"%Y-%m-%d %H:%M")"
}

dwm_battery() {
    [ -z "$BAT" ] && { printf "^c$grey^^b$grey^ --"; return; }
    CHARGE=$(cat "$BAT/capacity" 2>/dev/null)
    STATUS=$(cat "$BAT/status" 2>/dev/null)
    [ -z "$CHARGE" ] && { printf "^c$grey^^b$grey^ --"; return; }
    if [ "$STATUS" = "Charging" ]; then
        printf "^c$black^^b$green^ 󰂄 %s%%" "$CHARGE"
    elif [ "$CHARGE" -le 20 ]; then
        printf "^c$black^^b$red^ 󰁺 %s%%" "$CHARGE"
    else
        printf "^c$black^^b$cyan^ 󰁽 %s%%" "$CHARGE"
    fi
}

dwm_cpu() {
    read cpu user nice sys idle iowait irq softirq steal rest < /proc/stat
    total=$((user+nice+sys+idle+iowait+irq+softirq+steal))
    dtotal=$((total - prev_total))
    didle=$((idle - prev_idle))
    if [ "$dtotal" -ne 0 ]; then
        pct=$(( (dtotal - didle) * 100 / dtotal ))
    else
        pct=0
    fi
    prev_total=$total
    prev_idle=$idle
    printf "^c$black^^b$purple^ CPU: %d%%" "$pct"
}

dwm_mem() {
    memfree=$(($(awk '/MemAvailable:/ {print $2}' /proc/meminfo) / 1024))
    memtotal=$(($(awk '/MemTotal:/ {print $2}' /proc/meminfo) / 1024))
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

cached_ip=$(dwm_ip)
interval=0
while true; do
    [ $((interval % 15)) -eq 0 ] && cached_ip=$(dwm_ip)
    xsetroot -name "$(dwm_wifi)$(dwm_separator)$cached_ip$(dwm_separator)$(dwm_mem)$(dwm_separator)$(dwm_cpu)$(dwm_separator)$(dwm_battery)$(dwm_separator)$(dwm_date)$(dwm_emoji)"
    sleep 2
    interval=$((interval + 1))
done
