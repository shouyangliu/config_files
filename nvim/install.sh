#!/bin/bash
# sudo add-apt-repository ppa:neovim-ppa/unstable
# sudo apt update
# sudo apt install neovim
sudo apt install ripgrep
sudo apt install snap
sudo snap install nvim --channal=latest/stable --classic

sudo apt install git
sudo apt install xclip #neovim 使用系统剪切板

install_path=~/.local/share/nvim
mkdir $install_path/lazy/
lazy_path=$install_path/lazy
git clone https://github.com/folke/lazy.nvim.git $lazy_path/lazy.nvim
