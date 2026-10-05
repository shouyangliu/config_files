#!/bin/bash
set -e

cd "$(dirname "$0")"

# 不跑 `git submodule update --init --recursive`：
# picom/.gitmodules 是空文件、picom/ 也没有自己的 .git，这条命令会一路上溯作用到
# dotfiles 主仓库，主仓库里只要有未配置 url 的 gitlink 就会 fatal 退出
# （曾报 "No url found for submodule path '../dwl'"，路径还是相对 picom/ 打印的）。
# picom 本来也没有子模块要拉。

# build/ 若由不同版本的 meson 创建，直接 setup 会报
#   build data file ".../build/meson-private/build.dat" references functions
#   or classes that don't exist
# 并因 set -e 中断整个安装，所以先清掉旧的构建目录再配置。
rm -rf build
meson setup --buildtype=release . build
ninja -C build
sudo ninja -C build install

echo "picom installed."