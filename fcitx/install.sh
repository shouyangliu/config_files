#!/bin/bash
set -e

sudo apt install -y fcitx5 fcitx5-chinese-addons fcitx5-config-qt im-config

mkdir -p "$HOME/.config/fcitx5" "$HOME/.local/share/fcitx5"

cat > "$HOME/.config/fcitx5/profile" << 'EOF'
[Groups/0]
Name=Default
EnabledInputMethods=keyboard-us;Pinyin;

[Group 0]
DefaultLayout=us
DefaultIM=Pinyin

[InputMethods]
Keyboard-us=ghg;ghh;ghi;ghj;ghk;ghl;ghm;ghn;gho;ghp;
Pinyin=ghq;
EOF

cat > "$HOME/.config/fcitx5/conf/keyboard.conf" << 'EOF'
[Hotkeys]
TriggerKey=Super+space

[Layout]
DefaultGroup=us
GroupNames=us:US
EOF

cat > "$HOME/.local/share/fcitx5/inputmethod.conf" << 'EOF'
[InputMethods]
EnabledIMs=keyboard-us;Pinyin;
DefaultIM=keyboard-us
EOF

echo "fcitx5 installed."