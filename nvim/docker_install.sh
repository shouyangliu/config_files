#!/bin/bash
apt update
apt install software-properties-common
add-apt-repository ppa:neovim-ppa/unstable
apt update
apt install neovim

apt install git
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

#sudo apt install clangd-12
#sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100
#pip3 isntall cmake-language-server
apt install npm
npm install -g n
source ~/.bashrc
n stable
#sudo npm i -g pyright
apt install xclip #neovim 使用系统剪切板

install_path=~/.local/share/nvim
mkdir $install_path/lazy/
lazy_path=$install_path/lazy
git clone https://gitee.com/dinary/lazy.nvim.git $lazy_path/lazy.nvim
git clone https://gitee.com/shouyangliu/barbecue.nvim.git $lazy_path/barbecue
git clone https://gitee.com/shouyangliu/bufferline.nvim.git $lazy_path/bufferline.nvim
git clone https://gitee.com/mirror_jedsek/cmp-buffer.git $lazy_path/cmp-buffer
git clone https://gitee.com/guoqishiping/cmp-cmdline.git $lazy_path/cmp-cmdline
git clone https://gitee.com/guoqishiping/cmp-nvim-lsp.git $lazy_path/cmp-nvim-lsp
git clone https://gitee.com/guoqishiping/cmp-path.git $lazy_path/cmp-path
git clone https://gitee.com/zhengqijun/cmp-spell.git $lazy_path/cmp-spell
git clone https://gitee.com/shouyangliu/dashboard-nvim.git $lazy_path/dashboard-nvim
git clone https://gitee.com/hello-luiswu/flash.nvim.git $lazy_path/flash.nvim
git clone https://gitee.com/mirrors_jghauser/fold-cycle.nvim.git $lazy_path/fold-cycle.nvim
git clone https://gitee.com/mirrors_f-person/git-blame.nvim.git $lazy_path/git-blame.nvim
git clone https://gitee.com/zSpark/gitsigns.nvim.git $lazy_path/gitsigns.nvim
git clone https://gitee.com/shouyangliu/hlchunk.nvim.git $lazy_path/hlchunk.nvim
git clone https://gitee.com/nvim-plugin/lualine.nvim.git $lazy_path/lualine.nvim
git clone https://gitee.com/shouyangliu/neon.git $lazy_path/neon
git clone https://gitee.com/shouyangliu/noice.nvim.git $lazy_path/noice.nvim
git clone https://gitee.com/shouyangliu/nui.nvim.git $lazy_path/nui.nvim
git clone https://gitee.com/shouyangliu/nvim-cmp.git $lazy_path/nvim-cmp
git clone https://gitee.com/shouyangliu/nvim-lspconfig.git $lazy_path/nvim-lspconfig
git clone https://gitee.com/shouyangliu/nvim-navic $lazy_path/nvim-navic
git clone https://gitee.com/shouyangliu/nvim-notify.git $lazy_path/nvim-notify
git clone https://gitee.com/shouyangliu/nvim-treesitter.git $lazy_path/nvim-treesitter
git clone https://gitee.com/shouyangliu/nvim-web-devicons.git $lazy_path/nvim-web-devicons
git clone https://gitee.com/shouyangliu/plenary.nvim.git $lazy_path/plenary.nvim
git clone https://gitee.com/shouyangliu/satellite.nvim.git $lazy_path/satellite.nvim
git clone https://gitee.com/shouyangliu/telescope.nvim.git $lazy_path/telescope.nvim
git clone https://gitee.com/shouyangliu/toggleterm.nvim.git $lazy_path/toggleterm.nvim
git clone https://gitee.com/shouyangliu/nvim-tree.lua.git $lazy_path/nvim-tree.lua
git clone https://gitee.com/shouyangliu/mason-lspconfig.nvim.git $lazy_path/mason-lspconfig.nvim
git clone https://gitee.com/shouyangliu/mason.nvim.git $lazy_path/mason.nvim
# sudo apt install clangd
# wget https://apt.llvm.org/llvm.sh
# sudo chmod +x llvm.sh
# sudo ./llvm.sh 17
# sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-17 100
# sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-17 100
