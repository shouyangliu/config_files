#!/bin/bash

# 屏幕检测和配置脚本
# 检测所有连接的显示器，显示信息并让用户确认布局

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 默认配置
SKIP_GUI=false
AUTO_APPLY=false
FORCE_CLI=false

# 配置文件路径
CONFIG_DIR="$HOME/.config/dwm"
CONFIG_FILE="$CONFIG_DIR/monitors.conf"

# 显示帮助信息
show_help() {
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  --skip-gui    跳过图形界面，使用命令行界面"
    echo "  --auto-apply  自动应用配置，无需用户确认"
    echo "  --force-cli   强制使用命令行界面（即使有 zenity）"
    echo "  --help        显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0                    # 使用图形界面（如果可用）"
    echo "  $0 --skip-gui         # 使用命令行界面"
    echo "  $0 --auto-apply       # 自动应用配置"
    echo "  $0 --skip-gui --auto-apply  # 命令行界面 + 自动应用"
}

# 解析命令行参数
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-gui)
                SKIP_GUI=true
                shift
                ;;
            --auto-apply)
                AUTO_APPLY=true
                shift
                ;;
            --force-cli)
                FORCE_CLI=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                echo -e "${RED}未知选项: $1${NC}"
                show_help
                exit 1
                ;;
        esac
    done
}

# 检查是否安装了 xrandr
if ! command -v xrandr &> /dev/null; then
    echo -e "${RED}错误: 未安装 xrandr${NC}"
    echo "请先安装 xrandr: sudo apt install x11-xserver-utils"
    exit 1
fi

# 检查是否安装了 zenity（用于图形界面）
HAS_ZENITY=false
if command -v zenity &> /dev/null; then
    HAS_ZENITY=true
fi

# 获取所有连接的显示器
get_connected_monitors() {
    xrandr --query | grep " connected" | awk '{print $1}'
}

# 获取显示器的详细信息（分辨率、位置）
get_monitor_info() {
    local monitor=$1
    xrandr --query | grep "^${monitor} " | grep -oP '\d+x\d+\+\d+\+\d+' | head -1
}

# 解析显示器信息
parse_monitor_info() {
    local info=$1
    width=$(echo "$info" | cut -d'x' -f1)
    height=$(echo "$info" | cut -d'x' -f2 | cut -d'+' -f1)
    x_pos=$(echo "$info" | cut -d'+' -f2)
    y_pos=$(echo "$info" | cut -d'+' -f3)
}

# 显示显示器信息（命令行界面）
show_monitor_info_cli() {
    local monitors=("$@")
    local count=${#monitors[@]}
    
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}        屏幕检测结果${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
    echo -e "${GREEN}检测到 ${count} 个显示器:${NC}"
    echo ""
    
    for i in "${!monitors[@]}"; do
        local monitor="${monitors[$i]}"
        local info=$(get_monitor_info "$monitor")
        
        if [ -n "$info" ]; then
            parse_monitor_info "$info"
            echo -e "${YELLOW}显示器 $((i+1)): ${monitor}${NC}"
            echo -e "  分辨率: ${width}x${height}"
            echo -e "  位置:   (${x_pos}, ${y_pos})"
            echo ""
        fi
    done
    
    # 显示布局示意图
    echo -e "${CYAN}布局示意图:${NC}"
    echo ""
    
    if [ "$count" -eq 1 ]; then
        echo -e "  ${GREEN}┌─────────────────────┐${NC}"
        echo -e "  ${GREEN}│     ${monitors[0]}      │${NC}"
        echo -e "  ${GREEN}│    单屏幕模式       │${NC}"
        echo -e "  ${GREEN}└─────────────────────┘${NC}"
    elif [ "$count" -eq 2 ]; then
        # 获取两个显示器的信息
        local info1=$(get_monitor_info "${monitors[0]}")
        local info2=$(get_monitor_info "${monitors[1]}")
        parse_monitor_info "$info1"
        local x1=$x_pos
        parse_monitor_info "$info2"
        local x2=$x_pos
        
        if [ "$x1" -lt "$x2" ]; then
            echo -e "  ${GREEN}┌──────────────┐${NC}${BLUE}┌──────────────┐${NC}"
            echo -e "  ${GREEN}│   ${monitors[0]}    │${NC}${BLUE}│    ${monitors[1]}   │${NC}"
            echo -e "  ${GREEN}│    左屏      │${NC}${BLUE}│    右屏      │${NC}"
            echo -e "  ${GREEN}└──────────────┘${NC}${BLUE}└──────────────┘${NC}"
        else
            echo -e "  ${BLUE}┌──────────────┐${NC}${GREEN}┌──────────────┐${NC}"
            echo -e "  ${BLUE}│    ${monitors[1]}   │${NC}${GREEN}│   ${monitors[0]}    │${NC}"
            echo -e "  ${BLUE}│    左屏      │${NC}${GREEN}│    右屏      │${NC}"
            echo -e "  ${BLUE}└──────────────┘${NC}${GREEN}└──────────────┘${NC}"
        fi
    elif [ "$count" -eq 3 ]; then
        echo -e "  ${GREEN}┌──────────────┐${NC}${BLUE}┌──────────────┐${NC}${YELLOW}┌──────────────┐${NC}"
        echo -e "  ${GREEN}│   ${monitors[0]}    │${NC}${BLUE}│    ${monitors[1]}   │${NC}${YELLOW}│    ${monitors[2]}   │${NC}"
        echo -e "  ${GREEN}│    左屏      │${NC}${BLUE}│    中屏      │${NC}${YELLOW}│    右屏      │${NC}"
        echo -e "  ${GREEN}└──────────────┘${NC}${BLUE}└──────────────┘${NC}${YELLOW}└──────────────┘${NC}"
    else
        echo -e "  ${YELLOW}多屏幕布局 (${count} 个显示器)${NC}"
        for monitor in "${monitors[@]}"; do
            echo -e "  - ${monitor}"
        done
    fi
    echo ""
}

# 显示显示器信息（图形界面）
show_monitor_info_gui() {
    local monitors=("$@")
    local count=${#monitors[@]}
    
    local info_text="检测到 ${count} 个显示器:\n\n"
    
    for i in "${!monitors[@]}"; do
        local monitor="${monitors[$i]}"
        local info=$(get_monitor_info "$monitor")
        
        if [ -n "$info" ]; then
            parse_monitor_info "$info"
            info_text+="显示器 $((i+1)): ${monitor}\n"
            info_text+="  分辨率: ${width}x${height}\n"
            info_text+="  位置:   (${x_pos}, ${y_pos})\n\n"
        fi
    done
    
    # 显示布局描述
    if [ "$count" -eq 1 ]; then
        info_text+="布局: 单屏幕模式"
    elif [ "$count" -eq 2 ]; then
        info_text+="布局: 双屏幕模式（左右排列）"
    elif [ "$count" -eq 3 ]; then
        info_text+="布局: 三屏幕模式（左中右排列）"
    else
        info_text+="布局: 多屏幕模式 (${count} 个显示器)"
    fi
    
    zenity --info \
        --title="屏幕检测结果" \
        --text="$info_text" \
        --width=400 \
        --height=300
}

# 让用户确认屏幕配置
confirm_monitor_config() {
    local monitors=("$@")
    local count=${#monitors[@]}
    
    if [ "$HAS_ZENITY" = true ]; then
        # 使用 zenity 进行图形化确认
        local config_options=""
        
        if [ "$count" -eq 1 ]; then
            config_options="单屏幕模式"
        elif [ "$count" -eq 2 ]; then
            config_options="双屏幕模式 - 左右排列
双屏幕模式 - 上下排列
仅使用主屏幕"
        elif [ "$count" -eq 3 ]; then
            config_options="三屏幕模式 - 左中右排列
三屏幕模式 - 上下排列
仅使用主屏幕"
        else
            config_options="多屏幕模式 (${count} 个显示器)
仅使用主屏幕"
        fi
        
        local choice=$(zenity --list \
            --title="选择屏幕布局" \
            --text="请选择屏幕布局模式:" \
            --column="选项" \
            --width=400 \
            --height=200 \
            $config_options)
        
        if [ -z "$choice" ]; then
            echo "用户取消了屏幕配置"
            return 1
        fi
        
        echo "$choice"
    else
        # 使用命令行界面进行确认
        echo -e "${CYAN}请选择屏幕布局:${NC}"
        echo ""
        
        if [ "$count" -eq 1 ]; then
            echo -e "1. 单屏幕模式"
            read -p "确认使用此配置? (y/n): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                echo "单屏幕模式"
            else
                return 1
            fi
        elif [ "$count" -eq 2 ]; then
            echo -e "1. 双屏幕模式 - 左右排列"
            echo -e "2. 双屏幕模式 - 上下排列"
            echo -e "3. 仅使用主屏幕"
            read -p "请选择 (1-3): " choice
            
            case $choice in
                1) echo "双屏幕模式 - 左右排列" ;;
                2) echo "双屏幕模式 - 上下排列" ;;
                3) echo "仅使用主屏幕" ;;
                *) echo "无效选择"; return 1 ;;
            esac
        elif [ "$count" -eq 3 ]; then
            echo -e "1. 三屏幕模式 - 左中右排列"
            echo -e "2. 三屏幕模式 - 上下排列"
            echo -e "3. 仅使用主屏幕"
            read -p "请选择 (1-3): " choice
            
            case $choice in
                1) echo "三屏幕模式 - 左中右排列" ;;
                2) echo "三屏幕模式 - 上下排列" ;;
                3) echo "仅使用主屏幕" ;;
                *) echo "无效选择"; return 1 ;;
            esac
        else
            echo -e "1. 多屏幕模式 (${count} 个显示器)"
            echo -e "2. 仅使用主屏幕"
            read -p "请选择 (1-2): " choice
            
            case $choice in
                1) echo "多屏幕模式" ;;
                2) echo "仅使用主屏幕" ;;
                *) echo "无效选择"; return 1 ;;
            esac
        fi
    fi
}

# 保存显示器配置
save_monitor_config() {
    local layout=$1
    local monitors=("$@")
    shift
    monitors=("$@")
    
    mkdir -p "$CONFIG_DIR"
    
    cat > "$CONFIG_FILE" << EOF
# 屏幕配置文件
# 由 detect_monitors.sh 自动生成
# 生成时间: $(date)

# 布局模式: $layout
LAYOUT="$layout"

# 检测到的显示器
EOF
    
    for i in "${!monitors[@]}"; do
        local monitor="${monitors[$i]}"
        local info=$(get_monitor_info "$monitor")
        parse_monitor_info "$info"
        
        cat >> "$CONFIG_FILE" << EOF
MONITOR_$((i+1))="$monitor"
MONITOR_$((i+1))_RESOLUTION="${width}x${height}"
MONITOR_$((i+1))_POSITION="${x_pos}x${y_pos}"
EOF
    done
    
    echo -e "${GREEN}配置已保存到: ${CONFIG_FILE}${NC}"
}

# 应用显示器配置
apply_monitor_config() {
    local layout=$1
    local monitors=("$@")
    shift
    monitors=("$@")
    
    echo -e "${CYAN}正在应用屏幕配置...${NC}"
    
    case "$layout" in
        "单屏幕模式")
            # 仅使用第一个显示器
            local primary="${monitors[0]}"
            xrandr --output "$primary" --auto --pos 0x0
            echo -e "${GREEN}已设置为单屏幕模式: ${primary}${NC}"
            ;;
        "双屏幕模式 - 左右排列")
            if [ ${#monitors[@]} -ge 2 ]; then
                local left="${monitors[0]}"
                local right="${monitors[1]}"
                local left_info=$(get_monitor_info "$left")
                parse_monitor_info "$left_info"
                local left_width=$width
                
                xrandr --output "$left" --auto --pos 0x0 \
                       --output "$right" --auto --pos "${left_width}x0"
                echo -e "${GREEN}已设置为左右排列: ${left} + ${right}${NC}"
            fi
            ;;
        "双屏幕模式 - 上下排列")
            if [ ${#monitors[@]} -ge 2 ]; then
                local top="${monitors[0]}"
                local bottom="${monitors[1]}"
                local top_info=$(get_monitor_info "$top")
                parse_monitor_info "$top_info"
                local top_height=$height
                
                xrandr --output "$top" --auto --pos 0x0 \
                       --output "$bottom" --auto --pos "0x${top_height}"
                echo -e "${GREEN}已设置为上下排列: ${top} + ${bottom}${NC}"
            fi
            ;;
        "三屏幕模式 - 左中右排列")
            if [ ${#monitors[@]} -ge 3 ]; then
                local left="${monitors[0]}"
                local center="${monitors[1]}"
                local right="${monitors[2]}"
                
                local left_info=$(get_monitor_info "$left")
                parse_monitor_info "$left_info"
                local left_width=$width
                
                local center_info=$(get_monitor_info "$center")
                parse_monitor_info "$center_info"
                local center_width=$width
                
                xrandr --output "$left" --auto --pos 0x0 \
                       --output "$center" --auto --pos "${left_width}x0" \
                       --output "$right" --auto --pos "$((left_width + center_width))x0"
                echo -e "${GREEN}已设置为左中右排列: ${left} + ${center} + ${right}${NC}"
            fi
            ;;
        "仅使用主屏幕")
            local primary="${monitors[0]}"
            # 关闭其他显示器
            for monitor in "${monitors[@]:1}"; do
                xrandr --output "$monitor" --off
            done
            xrandr --output "$primary" --auto --pos 0x0
            echo -e "${GREEN}已设置为仅使用主屏幕: ${primary}${NC}"
            ;;
        *)
            echo -e "${YELLOW}未知的布局模式: ${layout}${NC}"
            return 1
            ;;
    esac
}

# 主函数
main() {
    # 解析命令行参数
    parse_args "$@"
    
    echo -e "${CYAN}正在检测屏幕...${NC}"
    
    # 获取连接的显示器
    local monitors=()
    while IFS= read -r monitor; do
        monitors+=("$monitor")
    done < <(get_connected_monitors)
    
    local count=${#monitors[@]}
    
    if [ "$count" -eq 0 ]; then
        echo -e "${RED}未检测到任何显示器${NC}"
        exit 1
    fi
    
    # 确定是否使用图形界面
    local use_gui=false
    if [ "$HAS_ZENITY" = true ] && [ "$SKIP_GUI" = false ] && [ "$FORCE_CLI" = false ]; then
        use_gui=true
    fi
    
    # 显示显示器信息
    if [ "$use_gui" = true ]; then
        show_monitor_info_gui "${monitors[@]}"
    else
        show_monitor_info_cli "${monitors[@]}"
    fi
    
    # 让用户确认配置
    local layout=""
    if [ "$use_gui" = true ]; then
        layout=$(confirm_monitor_config "${monitors[@]}")
    else
        layout=$(confirm_monitor_config "${monitors[@]}")
    fi
    
    if [ $? -ne 0 ] || [ -z "$layout" ]; then
        echo -e "${YELLOW}已取消屏幕配置${NC}"
        exit 0
    fi
    
    # 保存配置
    save_monitor_config "$layout" "${monitors[@]}"
    
    # 询问是否立即应用
    if [ "$AUTO_APPLY" = true ]; then
        apply_monitor_config "$layout" "${monitors[@]}"
    elif [ "$use_gui" = true ]; then
        if zenity --question \
            --title="应用配置" \
            --text="是否立即应用屏幕配置?" \
            --width=300; then
            apply_monitor_config "$layout" "${monitors[@]}"
        else
            echo -e "${YELLOW}配置已保存但未应用${NC}"
        fi
    else
        read -p "是否立即应用屏幕配置? (y/n): " apply_choice
        if [[ $apply_choice =~ ^[Yy]$ ]]; then
            apply_monitor_config "$layout" "${monitors[@]}"
        else
            echo -e "${YELLOW}配置已保存但未应用${NC}"
        fi
    fi
    
    echo -e "${GREEN}屏幕配置完成!${NC}"
}

# 运行主函数
main "$@"