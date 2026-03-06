#!/bin/bash

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian|linuxmint|pop) echo "debian" ;;
            arch|manjaro|endeavouros) echo "arch" ;;
            fedora|rhel|centos) echo "fedora" ;;
            *) echo "unknown" ;;
        esac
    else
        echo "unknown"
    fi
}

OS_TYPE=$(detect_os)

if command -v tmux &> /dev/null; then
    echo "tmux 已安装: $(tmux -V)"
    exit 0
fi

echo "安装 tmux..."

if [ "$OS_TYPE" = "debian" ]; then
    sudo apt install -y tmux
elif [ "$OS_TYPE" = "arch" ]; then
    sudo pacman -S --noconfirm tmux
elif [ "$OS_TYPE" = "fedora" ]; then
    sudo dnf install -y tmux
fi

if command -v tmux &> /dev/null; then
    echo "tmux 已安装: $(tmux -V)"
else
    echo "tmux 安装失败"
    exit 1
fi
