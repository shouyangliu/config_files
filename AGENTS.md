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
│   ├── theme.lua           #   主题结构（字体 / 边框 / 间隙）+ 一行配色开关
│   ├── themes/             #   8 套配色，一套一个文件（从 chadwm 搬来）
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
| `theme.lua` | 主题结构（字体 / 边框 / 间隙 / wibar 高度）+ 一行配色开关 |
| `themes/<名字>.lua` | 8 套调色板，只有颜色值，`theme.lua` 里选一套 |
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

**换主题 = 改 `awesome/theme.lua` 里的一行**，再 `Super+Shift+R` 热重载：

```lua
local THEME = "catppuccin"   -- 可选值见 awesome/themes/
```

8 套配色都是从原 chadwm 搬过来的，一套一个文件：
`catppuccin` / `dracula` / `everforest` / `gruvchad` / `nord` / `onedark` /
`tokyonight` / `tundra`。

分两层，改配色时别把结构性的东西抄进调色板文件里：

- `themes/<名字>.lua` —— 只有颜色值（`return { black = "#...", ... }`）。取值来自
  原 chadwm 的 `scripts/bar_themes/<名字>`（状态栏那份）和 `chadwm/themes/<名字>.h`
  （窗口那份，多出 `gray2` / `gray3`）。**两份文件同名键取值不一致时一律用 bar 那份**
  —— 状态栏是看着最久的那个。
- `theme.lua` —— 字体 / 边框宽度 / 间隙 / wibar 高度这些结构设置，外加把调色板铺到
  `beautiful` 的各字段上。**加一套新配色只要往 `themes/` 丢一个文件**（照抄现有文件，
  键集必须一致），结构性的东西不用重复写。

状态栏药丸用的自定义色键（`pill_fg` / `pill_bg` / `pill_grey` / `pill_green` /
`pill_blue` / `pill_red` / `pill_darkblue`）由 `theme.lua` 从调色板里填，
`widgets.lua` 启动时读取 —— 所以换主题会把药丸颜色一起换掉。

> awesome 自带的 5 套主题（default / gtk / sky / xresources / zenburn）**没有在用**：
> 它们配的是官方默认外观（标题栏、任务栏），没有药丸用的那几个色键，套上去药丸会没颜色。
> `theme.lua` 里那句 `dofile(get_themes_dir() .. "default/theme.lua")` 只是为了继承
> 布局图标等资源路径，不是在选择外观。

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

`awesome/install.sh` 除了装包和建软链，还会**自动做三步验证**，而且顺序是刻意的：

1. `awesome -k` 语法检查（`rc.lua`）
2. `themes/` 下的 8 套配色逐个语法检查 —— 只有被选中的那套会在实跑里加载，
   其余 7 套平时不会被碰到，等切过去才发现是坏的
3. 在 Xephyr 嵌套 X 服务器里真跑一遍（`AWESOME_NO_AUTOSTART=1` 跳过自启），
   扫输出里的 Lua 报错特征串
4. **只有上面都过了**，才删旧的 dwm/chadwm —— 这样任何一步失败都不会让你卡在
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