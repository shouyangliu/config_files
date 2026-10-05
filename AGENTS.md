# 项目背景

这是一个 **dotfiles** 项目，存放在 `~/config_files`。
（本项目会在多台机器上用，各自家目录名不同，所以文档里一律用 `~`，不写死绝对路径。）

## 核心原则

1. **所有配置文件使用软连接** - 不直接编辑 `~/.config/` 下的文件，而是通过软连接指向本项目
2. **路径使用软连接后的路径** - 配置文件中的路径应使用 `~/.config/xxx` 而非 `~/config_files/xxx`
3. **一键配置** - 运行 `./install.sh` 可完整配置 Ubuntu 环境

## 目录结构

```
config_files/
├── install.sh              # 主安装脚本
├── awesome/                # Awesome WM（Lua 配置，热重载，自带状态栏）
│   ├── rc.lua              #   主配置：布局 / 快捷键 / 规则 / 自启
│   ├── theme.lua           #   配色主题（catppuccin）
│   ├── widgets.lua         #   状态栏部件（彩色药丸）
│   ├── install.sh          #   装包 + 软链 + 验证（见下）
│   └── .Xresources         #   软链到 ~/.Xresources
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
| `awesome/` | `~/.config/awesome` |
| `awesome/.Xresources` | `~/.Xresources` |

## 窗口管理器（awesome）

从 dwm/chadwm 换成了 **awesome**：配置是 Lua，改完 `Super+Shift+R` 热重载，
**不需要重编译**（这正是换掉 dwm 系的原因）。状态栏是 awesome 自带的 wibar，
不用再单独维护一套 bar 脚本。

| 文件 | 作用 |
|------|------|
| `rc.lua` | 布局 / 快捷键 / 窗口规则 / 自启 |
| `theme.lua` | 配色（catppuccin），即 `beautiful` 主题表 |
| `widgets.lua` | 状态栏的彩色药丸部件参数：CPU / 电池 / 内存 / 无线 / 时钟 / 更新数 |

几个容易踩的点（都已按实测处理，改的时候别改回去）：

- **`awful.widget.watch` 不过 shell**。它内部走 `spawn.easy_async`（不是
  `easy_async_with_shell`），字符串命令只做分词，所以管道、通配符、重定向都无效。
  `widgets.lua` 里一律用 `{ "/bin/sh", "-c", cmd }` 的表形式。
- **`watch` 的默认回调不过滤换行**，`stdout` 带尾部 `\n` 会让状态栏多出一行高度，
  所以每个部件都自己写了回调去空白。
- **declarative 语法不接受裸字符串当孩子**。`wibox.widget { "文字", widget = ... }`
  会报 `attempt to index a string value`，字符串必须包成 textbox。
- **`awful.spawn.once` 不抗 `awesome.restart()`**（去重表在 Lua 侧，重启后为空）。
  自启段因此用 shell 的 `pgrep` / 标记文件自己兜底，否则每次 `Super+Shift+R`
  都会把亮度拍回 10%、并尝试起第二个 picom。

## 主题切换（awesome）

配色集中在 **一个文件**：`awesome/theme.lua`。改完 `Super+Shift+R` 热重载即可。

状态栏药丸用的自定义色键（`pill_fg` / `pill_grey` / `pill_green` / `pill_blue` /
`pill_red` / `pill_darkblue`）也在这个文件里，`widgets.lua` 启动时读取。

> **迁移遗留**：原 chadwm 有 8 套配色（catppuccin / dracula / everforest / gruvchad /
> nord / onedark / tokyonight / tundra），目前只搬了 **catppuccin**（迁移时正在用的那套）。
> 要用别的配色，需要照 `theme.lua` 新建一份。

## 快捷键与外部程序的对应

键位在 `awesome/rc.lua` 的 `globalkeys` / `clientkeys` 里。以下依赖**不在**
Ubuntu 默认安装里，已替换成本机可用的：

| 键位 | 原绑定（dwm/chadwm） | 现绑定（awesome） |
|---|---|---|
| `Super+Return` | `wezterm start --always-new-process` | 同 |
| `Super+C` | `rofi -show drun` | 同 |
| `Super+U` | `flameshot gui` | 同 |
| `Super+Ctrl+U` | `flameshot full -c` | 同 |
| `Super+Q` | `killclient` | `c:kill()` |
| `Super+E` / `Super+Shift+E` | `hidewin` / `restorewin` | `c.minimized` / `awful.client.restore()` |
| `Super+B` | `togglebar` | 切换 wibar `visible` |
| `Super+I` / `Super+D` | `incnmaster ±1` | `awful.tag.incnmaster` |
| `XF86 音量` | `pactl` | 同 |
| `XF86 亮度` | `light -A/-U 5`（未装） | `brightnessctl set +5%` / `5%-` |

**dwm 有、awesome 没有对应物、已放弃的**：`Super+Shift+Return` zoom、`setcfact`、
`setborderpx`、以及 `incrgaps` 那一整族多档间隙键（awesome 只有 `theme.useless_gap`
一个值）。

## 安装与验证

`awesome/install.sh` 除了装包和建软链，还会**自动做两步验证**，而且顺序是刻意的：

1. `awesome -k` 语法检查
2. 在 Xephyr 嵌套 X 服务器里真跑一遍（`AWESOME_NO_AUTOSTART=1` 跳过自启），
   扫输出里的 Lua 报错特征串
3. **只有上面都过了**，才删旧的 dwm/chadwm —— 这样任何一步失败都不会让你卡在
   「没有可用窗口管理器」的状态

在另一台机器上部署时直接 `./install.sh` 即可，不需要手动比对。

## 关键约定

- **修改配置时**：修改 `~/config_files/xxx/`，然后同步到软链接目标
- **脚本路径**：使用 `~/.config/xxx` 形式，便于迁移
- **安装脚本**：每个子模块可有自己的 `install.sh`，主脚本会依次调用

## 使用方式

```bash
# 一键配置
cd ~/config_files
./install.sh

# 手动同步软连接
ln -snf ~/config_files/xxx ~/.config/xxx
```

## 注意事项

1. 项目内配置文件应使用 `~/.config/xxx` 路径（软链接后的路径）
2. 如需修改路径，先确认软链接已正确创建
3. 每次修改后，确保软链接目标是最新的