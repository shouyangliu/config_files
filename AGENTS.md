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
├── dwm/                   # DWM 窗口管理器
├── dwmblocks/             # DWM 状态栏模块
├── polybar/               # Polybar 状态栏
├── picom/                 # Picom 合成器
├── nvim/                  # Neovim 配置
├── wezterm/               # WezTerm 终端
├── tmux/                  # Tmux 配置
├── bash/                  # Bash 配置
├── rofi_theme/            # Rofi 主题
├── wallpaper/             # 壁纸目录
├── slstatus/              # slstatus 配置
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
| `polybar/` | `~/.config/polybar` |
| `rofi_theme/` | `~/.config/rofi` |
| `slstatus/` | `~/.config/slstatus` |
| `dwm/` | 需编译安装 |
| `dwmblocks/` | 需编译安装 |

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