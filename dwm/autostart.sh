#!/bin/sh

# Input method
fcitx5 -d &

# Status bar
~/.config/dwm/bar/dwm_bar.sh &

# Wallpaper (optional)
# feh --randomize --bg-fill ~/.config/wallpaper/ &

# Compositor
# picom --config ~/.config/picom/picom.conf &

# 应用屏幕配置（如果存在）
MONITORS_CONF="$HOME/.config/dwm/monitors.conf"
if [ -f "$MONITORS_CONF" ]; then
    # 读取配置文件
    . "$MONITORS_CONF"
    
    # 应用布局
    case "$LAYOUT" in
        "单屏幕模式")
            if [ -n "$MONITOR_1" ]; then
                xrandr --output "$MONITOR_1" --auto --pos 0x0
            fi
            ;;
        "双屏幕模式 - 左右排列")
            if [ -n "$MONITOR_1" ] && [ -n "$MONITOR_2" ]; then
                # 获取第一个显示器的宽度
                WIDTH1=$(xrandr | grep "^${MONITOR_1} " | grep -oP '\d+x\d+' | cut -d'x' -f1)
                xrandr --output "$MONITOR_1" --auto --pos 0x0 \
                       --output "$MONITOR_2" --auto --pos "${WIDTH1}x0"
            fi
            ;;
        "双屏幕模式 - 上下排列")
            if [ -n "$MONITOR_1" ] && [ -n "$MONITOR_2" ]; then
                # 获取第一个显示器的高度
                HEIGHT1=$(xrandr | grep "^${MONITOR_1} " | grep -oP '\d+x\d+' | cut -d'x' -f2)
                xrandr --output "$MONITOR_1" --auto --pos 0x0 \
                       --output "$MONITOR_2" --auto --pos "0x${HEIGHT1}"
            fi
            ;;
        "三屏幕模式 - 左中右排列")
            if [ -n "$MONITOR_1" ] && [ -n "$MONITOR_2" ] && [ -n "$MONITOR_3" ]; then
                # 获取显示器宽度
                WIDTH1=$(xrandr | grep "^${MONITOR_1} " | grep -oP '\d+x\d+' | cut -d'x' -f1)
                WIDTH2=$(xrandr | grep "^${MONITOR_2} " | grep -oP '\d+x\d+' | cut -d'x' -f1)
                xrandr --output "$MONITOR_1" --auto --pos 0x0 \
                       --output "$MONITOR_2" --auto --pos "${WIDTH1}x0" \
                       --output "$MONITOR_3" --auto --pos "$((WIDTH1 + WIDTH2))x0"
            fi
            ;;
        "仅使用主屏幕")
            if [ -n "$MONITOR_1" ]; then
                # 关闭其他显示器
                for i in 2 3 4 5; do
                    eval "MON=\$MONITOR_$i"
                    if [ -n "$MON" ]; then
                        xrandr --output "$MON" --off
                    fi
                done
                xrandr --output "$MONITOR_1" --auto --pos 0x0
            fi
            ;;
    esac
fi