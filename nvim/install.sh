#!/bin/bash

INSTALL_PLUGINS=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --with-plugins)
            INSTALL_PLUGINS=true
            shift
            ;;
        *)
            echo "未知参数: $1"
            exit 1
            ;;
    esac
done

sudo apt install -y ripgrep git xclip curl

sudo apt install -y software-properties-common
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y neovim

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -L "$HOME/.config/nvim" ]; then
    echo "配置文件已存在，跳过链接"
else
    echo "创建 nvim 配置链接..."
    ln -sf "$SCRIPT_DIR" "$HOME/.config/nvim"
fi

if [ "$INSTALL_PLUGINS" = true ]; then
    echo "安装所有插件..."
    nvim +'Lazy! sync' +qa 2>/dev/null || echo "插件安装可能需要更多时间，请手动运行 nvim"
else
    echo "仅安装 lazy.nvim，首次运行 nvim 时会自动安装插件"
fi

echo "完成！"
