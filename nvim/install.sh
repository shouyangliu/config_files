#!/bin/bash
set -e

sudo apt install -y ripgrep git curl

# 直接从 GitHub 下载最新稳定版，兼容所有 Ubuntu 版本
NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
echo "Installing Neovim $NVIM_VERSION..."

# 带重试的下载函数
download_with_retry() {
    local url="$1"
    local output="$2"
    local max_retries=3
    local retry=0
    local GH_PROXY="${GH_PROXY:-https://ghproxy.net}"

    while [ $retry -lt $max_retries ]; do
        if curl -fL --connect-timeout 10 --max-time 120 -o "$output" "$url"; then
            return 0
        fi
        retry=$((retry + 1))
        echo "Download failed, retrying ($retry/$max_retries)..."
        sleep 2
    done

    # 回退到 ghproxy
    echo "Direct download failed, trying ghproxy mirror..."
    curl -fL --connect-timeout 10 --max-time 120 -o "$output" "${GH_PROXY}/${url}"
}

download_with_retry "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz" "nvim-linux-x86_64.tar.gz"
sudo tar -C /usr/local -xzf nvim-linux-x86_64.tar.gz --strip-components=1
rm -f nvim-linux-x86_64.tar.gz

echo "Neovim installed: $(nvim --version | head -1)"

# 检查版本，低于 0.12 则报错
NVIM_INSTALLED_VER=$(nvim --version | head -1 | grep -oP 'v\K[0-9]+\.[0-9]+')
if [ "$(echo "$NVIM_INSTALLED_VER < 0.12" | bc -l)" -eq 1 ]; then
    echo "Error: Neovim $NVIM_INSTALLED_VER is too old, requires >= 0.12"
    exit 1
fi