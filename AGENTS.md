# 项目背景

这是一个 **dotfiles** 项目，存放在 `/home/y/config_files`。

## 核心原则

1. **所有配置文件使用软连接** - 不直接编辑 `~/.config/` 下的文件，而是通过软连接指向本项目
2. **路径使用软连接后的路径** - 配置文件中的路径应使用 `~/.config/xxx` 而非 `/home/y/config_files/xxx`
3. **一键配置** - 运行 `./install.sh` 可完整配置 Ubuntu 环境

## 目录结构

```
config_files/
├── install.sh              # 主安装脚本
├── chadwm/                # Chadwm 窗口管理器（dwm 分支，当前使用）
│   ├── chadwm/            #   源码；config.h 与 config.def.h 均需改，改完重编译
│   ├── scripts/           #   状态栏 bar.sh + bar_themes/ 配色
│   ├── eww/               #   eww widget 面板（默认不装，见下）
│   └── .Xresources        #   软链到 ~/.Xresources
├── dwm/                   # 旧 DWM（已弃用，仅保留备用）
├── picom/                 # Picom 合成器
├── nvim/                  # Neovim 配置
├── wezterm/               # WezTerm 终端
├── tmux/                  # Tmux 配置
├── bash/                  # Bash 配置
├── rofi_theme/            # Rofi 主题
├── wallpaper/             # 壁纸目录
├── fcitx/                 # Fcitx 输入法配置
└── nerdfont/              # 字体文件
```

## 软连接对应关系

| 项目内路径 | 软链接位置 |
|-----------|-----------|
| `nvim/` | `~/.config/nvim` |
| `tmux/.tmux.conf` | `~/.tmux.conf` |
| `picom/picom.conf` | `~/.picom.conf` |
| `wezterm/wezterm.lua` | `~/.config/wezterm/wezterm.lua` |
| `wallpaper/` | `~/.config/wallpaper` |
| `rofi_theme/` | `~/.config/rofi` |
| `chadwm/` | `~/.config/chadwm` |
| `chadwm/.Xresources` | `~/.Xresources` |

## 主题切换（chadwm）

主题需在 **3 处**同步，否则配色会不一致：

| 位置 | 改什么 | 是否需重编译 |
|------|--------|-------------|
| `chadwm/chadwm/config.h` 与 `config.def.h` | `#include "themes/xxx.h"` | 是 |
| `chadwm/scripts/bar.sh` | `. .../bar_themes/xxx` | 否 |
| `chadwm/eww/eww.scss` | `@import "scss/themes/xxx.scss"` | 否 |

可选值：catppuccin / dracula / everforest / gruvchad / nord / onedark / tokyonight / tundra

> **注意**：`chadwm/chadwm/Makefile` 的 `clean` 目标会 `rm -f config.h`，而 config.h 规则是
> `cp config.def.h`。所以**不要用 `make clean`**，否则本地 config.h 会被 config.def.h 覆盖。

## eww（默认不安装）

`install.sh` **不安装 eww**：上游 6 个 release 全部没有预编译产物，Ubuntu 源里也没有，
只能从源码编译：

```bash
cargo install --locked --no-default-features --features x11 \
    --git https://github.com/elkowar/eww --tag v0.6.0
```

⚠️ 不要用 `cargo install eww` —— crates.io 上那个同名的 `eww` 是**另一个项目**
（egui backend，2021 年的 0.0.1-alpha），装出来不是这个 eww。

未安装时状态栏上那个 eww 图标点了没反应（`Super+E` 是 `hidewin`，与 eww 无关），
其余功能（WM、状态栏）不受影响。

## 快捷键与外部程序的对应

改 `config.h` 里的键位时注意，以下依赖**不在** Ubuntu 默认安装里，已替换成本机可用的：

| 键位 | 原绑定 | 现绑定 |
|---|---|---|
| `XF86XK_MonBrightnessUp/Down` | `light -A/-U 5`（未装） | `brightnessctl set +5%` / `5%-` |
| `Super+Ctrl+U`（截全屏） | `maim \| xclip`（maim 未装） | `flameshot full -c` |
| `Super+U`（截选区） | `maim --select \| xclip` | `flameshot gui` |
| 中键点状态栏 | `st`（未装） | `wezterm start --always-new-process` |

`config.h` 是本地文件（`.gitignore` 已忽略），但按本仓库约定 `config.def.h` 也要同步改，
否则 `make clean` 后改动会丢。上表两个文件都已改。

## 关键约定

- **修改配置时**：修改 `/home/y/config_files/xxx/`，然后同步到软链接目标
- **脚本路径**：使用 `~/.config/xxx` 形式，便于迁移
- **安装脚本**：每个子模块可有自己的 `install.sh`，主脚本会依次调用

## 使用方式

```bash
# 一键配置
cd /home/y/config_files
./install.sh

# 手动同步软连接
ln -snf /home/y/config_files/xxx ~/.config/xxx
```

## 注意事项

1. 项目内配置文件应使用 `~/.config/xxx` 路径（软链接后的路径）
2. 如需修改路径，先确认软链接已正确创建
3. 每次修改后，确保软链接目标是最新的