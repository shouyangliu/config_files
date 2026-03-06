#!/bin/bash

echo ">>> 正在更新软件包列表..."
sudo apt update

echo ">>> 正在安装 Fcitx5 及中文组件..."
sudo apt install -y fcitx5 fcitx5-chinese-addons fcitx5-config-qt im-config

echo ">>> 正在配置系统环境变量..."

mkdir -p "$HOME/.config/fcitx5"

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

FCITX_CONFIG_DIR="$HOME/.local/share/fcitx5"
mkdir -p "$FCITX_CONFIG_DIR"

cat > "$FCITX_CONFIG_DIR/inputmethod.conf" << 'EOF'
[InputMethods]
EnabledIMs=keyboard-us;Pinyin;
DefaultIM=keyboard-us
EOF

echo ">>> 安装与配置全部完成！"
echo "请在 ~/.xprofile 或 ~/.profile 中添加以下内容："
echo ""
echo "export GTK_IM_MODULE=fcitx"
echo "export QT_IM_MODULE=fcitx"
echo "export XMODIFIERS=@im=fcitx"
echo "fcitx5 -d"
echo ""
echo "然后重启电脑或重新登录。"