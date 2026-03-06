#!/bin/bash

echo "正在检查 Rofi 是否已安装..."
if ! command -v rofi &> /dev/null; then
    echo "Rofi 未安装，请先安装：sudo apt install rofi"
    exit 1
fi

CONFIG_DIR="$HOME/.config/rofi"
THEME_FILE="$CONFIG_DIR/dracula.rasi"

mkdir -p "$CONFIG_DIR"

echo "正在安装 adi1090x Type-6 主题..."

cat > "$THEME_FILE" << 'EOF'
configuration {
    modi: "drun";
    show-icons: true;
    display-drun: "Apps";
    drun-display-format: "{name}";
}

* {
    font: "JetBrains Mono 10";
    background: #180F39;
    background-alt: #32197D;
    foreground: #FFFFFF;
    selected: #FF00F1;
    active: #9878FF;
    urgent: #7D0075;
}

window {
    transparency: "real";
    location: center;
    anchor: center;
    fullscreen: false;
    width: 900px;
    height: 500px;
    border-radius: 15px;
    background-color: @background;
}

mainbox {
    enabled: true;
    spacing: 0px;
    background-color: transparent;
    orientation: horizontal;
    children: [ "imagebox", "listbox" ];
}

imagebox {
    enabled: true;
    padding: 20px;
    background-color: @background-alt;
    width: 280px;
    orientation: vertical;
    children: [ "inputbar", "dummy", "mode-switcher" ];
}

listbox {
    enabled: true;
    spacing: 15px;
    padding: 20px;
    background-color: @background;
    orientation: vertical;
    children: [ "message", "listview" ];
}

dummy { background-color: transparent; }

inputbar {
    enabled: true;
    spacing: 10px;
    padding: 15px;
    border-radius: 10px;
    background-color: @background;
    text-color: @foreground;
    children: [ "textbox-prompt-colon", "entry" ];
}

textbox-prompt-colon {
    enabled: true;
    expand: false;
    str: "🔍";
    background-color: @selected;
    text-color: @background;
    padding: 8px;
    border-radius: 5px;
}

entry {
    enabled: true;
    background-color: inherit;
    text-color: inherit;
    cursor: text;
    placeholder: "Search...";
    placeholder-color: #9878FF;
}

mode-switcher {
    enabled: true;
    spacing: 15px;
    background-color: transparent;
    text-color: @foreground;
}

button {
    padding: 12px 20px;
    border-radius: 10px;
    background-color: @background;
    text-color: inherit;
    cursor: pointer;
}

button selected {
    background-color: @selected;
    text-color: @foreground;
}

listview {
    enabled: true;
    columns: 1;
    lines: 8;
    cycle: true;
    scrollbar: false;
    fixed-height: true;
    spacing: 8px;
    background-color: transparent;
    text-color: @foreground;
}

element {
    enabled: true;
    spacing: 12px;
    padding: 10px;
    border-radius: 10px;
    background-color: transparent;
    text-color: @foreground;
    cursor: pointer;
}

element selected.normal {
    background-color: @selected;
    text-color: @foreground;
}

element normal.urgent {
    background-color: @urgent;
    text-color: @foreground;
}

element normal.active {
    background-color: @active;
    text-color: @foreground;
}

element-icon {
    background-color: transparent;
    text-color: inherit;
    size: 28px;
}

element-text {
    background-color: transparent;
    text-color: inherit;
    vertical-align: 0.5;
}

message { background-color: transparent; }

textbox {
    padding: 12px;
    border-radius: 10px;
    background-color: @background-alt;
    text-color: @foreground;
}
EOF

cat > "$CONFIG_DIR/config.rasi" << EOF
@import "dracula.rasi"
EOF

echo "=================================="
echo " 主题安装完成！"
echo " 测试命令：rofi -show drun"
echo "=================================="
