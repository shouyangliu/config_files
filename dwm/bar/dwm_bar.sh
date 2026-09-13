#!/bin/bash

# Colors - Tokyo Night
black="#1a1b26"
grey="#414868"
blue="#7aa2f7"
green="#9ece6a"
red="#f7768e"
yellow="#e0af68"
purple="#bb9af7"
cyan="#7dcfff"
orange="#ff9e64"

# 预计算 CPU（非阻塞方式）
get_cpu() {
    read cpu a b c previdle rest < /proc/stat
    prevtotal=$((a+b+c+previdle))
    # 后台延迟计算
    (sleep 0.5 && read cpu a b c idle rest < /proc/stat && \
     total=$((a+b+c+idle)) && \
     diff_idle=$((idle-previdle)) && \
     diff_total=$((total-prevtotal)) && \
     if [ "$diff_total" -gt 0 ]; then
         cpu=$((100*(diff_total-diff_idle)/diff_total))
     else
         cpu=0
     fi && \
     echo "$cpu" > /tmp/dwm_cpu) &
    cat /tmp/dwm_cpu 2>/dev/null || echo "0"
}

# 初始化 CPU 文件
read cpu a b c previdle rest < /proc/stat
echo "0" > /tmp/dwm_cpu

while true; do
    # 获取各模块状态
    # WiFi
    ssid=$(iwgetid -r 2>/dev/null)
    if [ -z "$ssid" ]; then
        wifi="^c${grey}^^b${grey}^ 󰤭 --"
    else
        wifi="^c${black}^^b${cyan}^ 󰤨 ${ssid}"
    fi

    # IP
    ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    if [ -z "$ip" ]; then
        ipblock="^c${grey}^^b${grey}^ 󰈟 --"
    else
        ipblock="^c${black}^^b${yellow}^ 󰈟 ${ip}"
    fi

    # Memory
    memfree=$(($(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') / 1024))
    memtotal=$(($(grep -m1 'MemTotal:' /proc/meminfo | awk '{print $2}') / 1024))
    memused=$((memtotal - memfree))
    mempercent=$((memused * 100 / memtotal))
    mem="^c${black}^^b${green}^ MEM: ${memused}M ${mempercent}%"

    # CPU (后台更新)
    cpu=$(get_cpu)
    cpublock="^c${black}^^b${purple}^ CPU: ${cpu}%"

    # Battery
    BAT=$(ls /sys/class/power_supply/BAT* 2>/dev/null | head -1)
    CHARGE=$(cat "$BAT/capacity" 2>/dev/null)
    STATUS=$(cat "$BAT/status" 2>/dev/null)
    if [ -z "$CHARGE" ]; then
        battery="^c${grey}^^b${grey}^ 󰂑 --"
    elif [ "$STATUS" = "Charging" ]; then
        battery="^c${black}^^b${green}^ 󰂄 ${CHARGE}%"
    elif [ "$CHARGE" -le 20 ]; then
        battery="^c${black}^^b${red}^ 󰁺 ${CHARGE}%"
    else
        battery="^c${black}^^b${cyan}^ 󰁽 ${CHARGE}%"
    fi

    # Date
    dateblock="^c${black}^^b${orange}^ $(date '+%Y-%m-%d %H:%M') "

    # 更新状态栏
    xsetroot -name "${wifi} ${ipblock} ${mem} ${cpublock} ${battery} ${dateblock}"

    # 后台更新 CPU 供下次使用
    (read cpu a b c previdle rest < /proc/stat && \
     prevtotal=$((a+b+c+previdle)) && \
     sleep 0.5 && \
     read cpu a b c idle rest < /proc/stat && \
     total=$((a+b+c+idle)) && \
     diff_idle=$((idle-previdle)) && \
     diff_total=$((total-prevtotal)) && \
     if [ "$diff_total" -gt 0 ]; then
         cpu=$((100*(diff_total-diff_idle)/diff_total))
     else
         cpu=0
     fi && \
     echo "$cpu" > /tmp/dwm_cpu) &

    sleep 2
done
