#!/bin/bash


dwm_date () {
    printf "%s" "$SEP1"
    if [ "$IDENTIFIER" = "unicode" ]; then
        printf "📆 %s" "$(date +"%d-%m-%y %H:%M")"
    else
        printf " %s" "$(date +"%d-%m-%y 󰥔 %H:%M")"
    fi
    printf "%s\n" "$SEP2"
}

dwm_network () {
    CONNAME=$(nmcli -a | grep 'Wired connection' | awk 'NR==1{print $1}')
    if [ "$CONNAME" = "" ]; then
        CONNAME=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -c 5-)
    fi

    PRIVATE=$(nmcli -a | grep 'inet4 192' | awk '{print $2}')
    PUBLIC=$(curl -s https://ipinfo.io/ip)

    printf "%s" "$SEP1"
    if [ "$IDENTIFIER" = "unicode" ]; then
        printf "🌐 %s %s | %s" "$CONNAME" "$PRIVATE" "$PUBLIC"
    else
        printf "󰖩%s%s %s""$CONNAME"
    fi
    printf "%s\n" "$SEP2"
}

dwm_battery () {
    # Change BAT1 to whatever your battery is identified as. Typically BAT0 or BAT1
    CHARGE=$(cat /sys/class/power_supply/BAT1/capacity)
    STATUS=$(cat /sys/class/power_supply/BAT1/status)
    # full Discharging
    printf "%s" "$SEP1"
    if [ "$IDENTIFIER" = "unicode" ]; then
        if [ "$STATUS" = "Charging" ]; then
            printf "🔌 %s%% %s" "$CHARGE" #"$STATUS"
        else
            printf "🔋 %s%% %s" "$CHARGE" #"$STATUS"
        fi
    else
        if [ "$STATUS" = "Charging" ]; then
            printf " 󰂄 %s%% %s" "$CHARGE" #"$STATUS"
        else
            printf "󰁹 %s%% %s" "$CHARGE" #"$STATUS"
        fi

    fi
    printf "%s\n" "$SEP2"
}

dwm_alsa () {
    VOL=$(amixer get Master | tail -n1 | sed -r "s/.*\[(.*)%\].*/\1/")
    printf "%s" "$SEP1"
    if [ "$VOL" -eq 0 ]; then
        printf "󰕿"
    elif [ "$VOL" -gt 0 ] && [ "$VOL" -le 33 ]; then
        printf "󰖀 %s%%" "$VOL"
    elif [ "$VOL" -gt 33 ] && [ "$VOL" -le 66 ]; then
        printf "󰕾 %s%%" "$VOL"
    else
        printf "󱄡 %s%%" "$VOL"
    fi
    printf "%s\n" "$SEP2"
}

dwm_cpu(){
    read cpu a b c previdle rest < /proc/stat
    prevtotal=$((a+b+c+previdle))
    sleep 0.5
    read cpu a b c idle rest < /proc/stat
    total=$((a+b+c+idle))
    cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
    echo "󰧨 cpu : $cpu%"
}

print_mem(){
	memfree=$(($(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') / 1024))
	memtotal=$(($(grep -m1 'MemTotal:' /proc/meminfo | awk '{print $2}') / 1024 ))
    memused=$[$memtotal-$memfree]
    rate=$[$memused/$memtotal]

	echo " Mem : $memused"
}
# 

black="#1e222a"
white="#D8DEE9"
grey="#373d49"
blue="#81A1C1"
blue2="#5E81AC"
blue3="#88C0D0"
blue4="#8FBCBB"
red="#d47d85"
green="#A3BE8C"
pink="#B48EAD"
yellow="#EBCB8B"
orange="#D08770"
darkblue="#7292b2"

while true
do
xsetroot -name "^c$black^^b$blue^  󰤼: ^b$green^ $(print_mem) $(dwm_cpu) ^b$blue^^c$black^ $(dwm_network) ^c$black^^b$green^   $(dwm_date) ^b#81A1C1^  "
sleep 2
done

