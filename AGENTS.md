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
├── dwm/                    # dwm 6.5（窗口管理器：源码 + 自己打的补丁）
│   ├── config.h            #   快捷键 / 窗口配色 / 布局 / 规则（编译期生效）
│   ├── config.mk           #   版本 6.5 / 安装路径 / Xinerama 开关
│   ├── bar/dwm_bar.sh      #   状态栏脚本（彩色药丸，一行换配色）
│   ├── bar/themes/         #   状态栏 5 套配色
│   ├── autostart.sh        #   登录自启：picom / dunst / 锁屏看门狗 / fcitx5 / 状态栏
│   ├── patch/              #   打过的补丁存档（不是网上下载的原始 diff）
│   ├── .Xresources         #   软链到 ~/.Xresources（Xft 字体渲染）
│   └── install.sh          #   编译安装 + 建软链 + 装会话文件
├── dunst/                 # 通知守护进程（没有它，notify-send 发出去的通知会被丢弃）
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
| `dwm/` | `~/.config/dwm` |
| `dwm/.Xresources` | `~/.Xresources` |
| `dunst/dunstrc` | `~/.config/dunst/dunstrc` |
| `dwm/autostart.sh` | `~/.local/share/dwm/autostart.sh` |

> **仓库里所有软链都是相对路径。** 历史上 `rofi_theme/` 那 6 个（applets / colors /
> images / launchers / powermenu / scripts）和 `nvim/nvim` 用的是 `/home/y/...` 绝对
> 路径 —— 那是在另一台机器上建的、并且被提交进了 git，结果本机全是断链，**整套 rofi
> 扩展静默失效**（rofi 找不到 launchers/powermenu，不报错，就是没有那几个模式）。
> 2026-10 已全部改成相对路径。加新软链时**别用绝对路径**。

## 窗口管理器（dwm）

**dwm 6.5**，源码在 `dwm/`，自己打了 9 个补丁：statuscolors / status2d-systray /
extrabar / attachbelow / fullgaps-toggle / hide_vacant_tags / viewontag /
actualfullscreen / autostart，原件存档在 `dwm/patch/`。

| 文件 | 作用 | 改完要不要重编译 |
|------|------|----------------|
| `config.h` | 快捷键 / 窗口配色 / 布局 / 窗口规则 | **要** |
| `config.mk` | 版本 / 安装路径 / Xinerama | **要** |
| `bar/dwm_bar.sh` | 状态栏：彩色药丸，`THEME=` 一行换配色 | 不用 |
| `bar/themes/<名字>` | 状态栏 5 套配色 | 不用 |
| `autostart.sh` | 登录自启：picom + fcitx5 + 状态栏 | 不用（重登录生效） |
| `install.sh` | `make clean install` + 软链 + 装会话文件 | — |

**dwm 系最烦的一点：`config.h` 是编译进二进制的。** 改完必须

```bash
cd ~/.config/dwm && sudo make clean install   # 或重跑仓库的 ./install.sh
```

否则跑的还是旧配置 —— 但**状态栏不受这个限制**，它是独立脚本，改完重登录就生效。

> 仓库里 `dwm/` 连编译产物（`dwm`、`dwm.o`、`drw.o`、`util.o`）一起提交了，是历史遗留。
> `make clean` 会清掉、重新编译即可，别把 `dwm` 那个二进制当源码读。

### 自启脚本在哪（容易找错）

dwm 的 autostart patch **不看 `~/.config/dwm`**。`dwm/dwm.c` 的 `runautostart()` 按这个
顺序找 `autostart.sh`：

1. `$XDG_DATA_HOME/dwm/`（本机 `XDG_DATA_HOME` 没设，跳过）
2. `~/.local/share/dwm/`  ← **本机命中的是这条**
3. `~/.dwm/`（只有前两条的目录都不存在时才退到这里）

所以自启就改仓库里的 `dwm/autostart.sh`（`install.sh` 会把它软链到
`~/.local/share/dwm/autostart.sh`），改完注销重登生效。

> 这个软链原来两份 `install.sh` 里**都没有**建 —— 本机那份是 2026-07 手工建的，
> 也就是说不补上的话，换台新机器跑 `./install.sh` 会是「dwm 起来了但 picom 和状态栏
> 都没有」。2026-10 已补进 `dwm/install.sh`。

另外 `dwm.c` 跑完 autostart 后还会自己 `dbus-launch --exit-with-session fcitx5 -d`，
所以 `autostart.sh` 里那句 `fcitx5 &` 是重复的（无害，第二个实例自己退出）。

### 快捷键（以 `dwm/config.h` 为准）

`Super` = Mod4。这份 dwm 的键位**和 chadwm 不一样**，最容易按错的两个：
**`Super+Q` 是截图（flameshot）不是关窗**，关窗是 `Super+Shift+C`。

| 键位 | 动作 |
|---|---|
| `Super+Return` | wezterm |
| `Super+B` | **dmenu**（不是 rofi） |
| `Super+P` | rofi -show drun |
| `Super+W` | 换壁纸（`feh --randomize`） |
| `Super+Q` | **flameshot gui —— 截图，不是关窗** |
| `Super+Shift+C` | 关窗（killclient） |
| `Super+Escape` | 锁屏（slock） |
| `XF86 音量+ / 音量− / 静音` | `pactl`（`@DEFAULT_SINK@`，跟着当前默认输出走） |
| `XF86 亮度+ / 亮度−` | `brightnessctl set 10%+` / `10%-` |
| `Super+Shift+Return` | zoom：把窗口提到主区 |
| `Super+Shift+F` | 全屏 |
| `Super+Shift+E` | **退出 dwm** |
| `Super+J` / `Super+K` | 焦点上下 |
| `Super+H` / `Super+L` | 主区比例 ±0.05 |
| `Super+Space` | 循环布局 |
| `Super+Shift+Space` | 切浮动 |
| `Super+T` / `F` / `M` | 直接指定布局：tile / floating / monocle |
| `Super+-` / `Super+=` | 间隙 −5 / +5 |
| `Super+Shift+-` / `Super+Shift+=` | 间隙复位 / 开关 |
| `Super+Tab` | 切回上一个标签（`view {0}`） |
| `Super+0` / `Super+Shift+0` | 看全部标签 / 把窗口全移过去 |
| `Super+1..9` ×4 组 | 同 upstream dwm 的 `TAGKEYS`：本体 view、`+Ctrl` 叠加显示、`+Shift` 移窗口、`+Ctrl+Shift` 切换标记 |
| `Super+逗号` / `Super+句号` | 切显示器（`+Shift` = 把窗口移过去） |

鼠标：标签上左键 `view` / 右键 `toggleview` / `Super+左键` 把窗口移过去；
窗口上 `Super+左键` 移动 / `Super+中键` 切浮动 / `Super+右键` 缩放。

**这份 dwm 没有的键位**（按了没反应是正常的，不是坏了）：
`Super+I`/`Super+D`（主区窗口数）、`Super+Shift+J/K`（窗口换位）、
`Super+U`（截图）、`Super+E`（隐藏窗口）、间隙那一整族
`Super+Ctrl+6/7/8/9`。**这些全是 chadwm 才有的。**

> XF86 那几个多媒体键 2026-10 补上了，**不在上面这份"没有"名单里了**。补的时候踩到
> 一个坑：keysym 定义在 `<X11/XF86keysym.h>`，而 `dwm.c` 自己 include 了 Xlib.h /
> Xatom.h / Xproto.h / Xutil.h / Xft.h，**唯独没有这个头** —— `config.h` 里不自己补一句
> `#include <X11/XF86keysym.h>`，编译直接报 `XF86XK_AudioRaiseVolume undeclared`。
> 这也是 `config.h` 里唯一一处 include，别当成多余的东西删掉。

> **判断一台机器上跑的是哪套 dwm，看进程，不要看仓库。**
>
> ```bash
> ps -eo args | grep -E 'dwm_bar\.sh|scripts/bar\.sh'
> ```
>
> 出现 `bar/dwm_bar.sh` = 这份 dwm；出现 `scripts/bar.sh` = chadwm。
> **这个坑真踩过**：仓库文档曾经把两者标反（写 chadwm「当前使用」、dwm「已弃用」），
> 而实际天天跑的是 dwm —— 照着文档白折腾了一轮（先换 chadwm 再换 awesome）。
> 判定依据也是这么来的：`/proc/<pid>/exe` 指向 `/usr/local/bin/dwm`，
> 且状态栏进程的路径是 `~/.config/dwm/bar/dwm_bar.sh`。

## 换状态栏配色（dwm）

改 `dwm/bar/dwm_bar.sh` 里的一行，重登录（或重跑一次状态栏）即生效，**不用编译**：

```sh
THEME="catppuccin"   # 可选：catppuccin / gruvchad / nord / onedark / tokyonight
```

`bar/themes/<名字>` 里只有颜色值（`black="#1e1e2e"` 这种）。**加一套新配色只要往
`bar/themes/` 丢一个文件**，照抄现有文件、键集必须一致。

注意这跟窗口配色是两回事：窗口边框/标题的颜色硬编码在 `config.h` 里（Tokyo Night：
`col_gray1` / `col_cyan` 那一组），换状态栏主题不会动窗口，改窗口配色要重编译。

> chadwm 时代主题要在 3 处同步（`config.h` + `bar.sh` + `eww.scss`），dwm 只有这 2 处。

## 合成器（picom）

picom 是**从源码编译**的（`picom/install.sh` 走 meson/ninja，装到 `/usr/local/bin`），
不是 apt 包。源码就在 `picom/`，**是个 fork**：picom 9 本体 + 动画补丁
（`src/options.c` 里有 `--animations` / `--animation-stiffness-in-tag`，原版 picom 没有）。
`picom.conf` 顶上那句「animations 只在 phyOS-dwm fork 上正常工作」说的就是它。

> **`picom --version` 报的 `vgit-bbbf4` 不是 picom 的版本号。** `picom/meson.build` 里写的
> 是 `version: '9'`，但代码优先用 `git describe`，而 `picom/` 没有自己的 `.git` —— 那个
> `git rev-parse HEAD` 取到的是 **dotfiles 仓库**编译当天的提交（`bbbf472`）。
> 拿这个字符串去搜 picom 的问题是搜不到的。

圆角和模糊的开关**在 `dwm/autostart.sh` 的启动命令里，光改 `picom.conf` 没用**：

| 想要的效果 | 需要什么 | 不满足时会怎样 |
|---|---|---|
| 模糊（`dual_kawase`） | 启动加 `--experimental-backends` | 启动时警告 `Dual-kawase blur is not implemented by the legacy backends`，静默退化，`blur-strength` 白设 |
| 圆角（`corner-radius`） | 同上 + `backend = "glx"` | legacy 后端里源码把圆角写死 gate 在 glx：`render.c` 的 `corner_radius > 0 && backend == BKEND_GLX` |

原版 picom 9 里这两件事是**互斥**的（legacy 有圆角没 dual_kawase，实验后端反过来）；
这个 fork 两头都补上了，所以加 `--experimental-backends` 能同时拿到。代价是内存基线
从 ~69 MB 涨到 ~100 MB。

**内存：实测没有泄漏，别去追这个传言。** 2026-10 实测：真机连跑约 3 小时 RSS 稳在
68.9 MB 一个字节没涨；Xephyr 里反复开关窗口 200 次（动画开 / 动画关 / 实验后端各一组），
全部在 50 次后完全平台化，实验后端那组 200 次总增长仅 1.2 MB。启动时的一次性 +15~20 MB
是 GL 纹理和模糊 kernel 缓冲的预热。网上传的多半是
[yshui/picom#1383](https://github.com/yshui/picom/issues/1383)（**v12.3 主线**的
geometry-change 动画泄漏）和 #892（xrender + 实验后端），以及一批 v11 才修掉的老问题 ——
都不是这颗 9 代 fork。

## 安装与验证

`dwm/install.sh` 做五件事：`sudo make clean install` → 建 `~/.config/dwm`、
`~/.Xresources`、`~/.local/share/dwm/autostart.sh` 三个软链 → 把 `dwm.desktop` 装到
`/usr/share/xsessions/` → 清掉 awesome 留下的会话文件和 `~/.config/awesome`。
清理刻意放在最后：上面任何一步失败时，当前会话都还是完整的，不会卡在「没有可用窗口
管理器」的状态。

编译依赖：`libx11-dev libxinerama-dev libfontconfig-dev libxft-dev`
（`dwm/config.mk` 链的是 `-lXinerama -lfontconfig -lXft`）。**换 awesome 那轮把这三个
从主 `install.sh` 的清单里删掉了，恢复 dwm 时加回来了** —— 在一台没装过它们的机器上
编译会直接失败，别再删。

`~/.Xresources` 由 `/etc/X11/Xsession.d/30x11-common_xresources` 在登录时自动
`xrdb -merge`，里面只有 `Xft.*`（字体渲染）那几行；原 chadwm 那份里的 `st.*` /
`tabbed.*` / One Dark 色板没有任何程序会读（st、tabbed 都没装），已去掉。

在另一台机器上部署：`./install.sh`，然后注销、在登录界面选 dwm。

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
4. **仓库里只留一个窗口管理器。** 曾经同时躺过 `dwm/`、`chadwm/`、`awesome/` 三份，
   结果文档和实际在用的对不上（见上面那个坑）。两份旧的都还在 git 历史里，需要时取回：
   - chadwm：`git checkout e50dc51 -- chadwm`（8 套主题 + vanitygaps + eww）
   - awesome：`git checkout 6d2c49d -- awesome`（2026-10 试过一轮，判定不如 dwm）

   取回后记得同步改 `install.sh` 里的 `run_module` 和 `~/.config` 软链。
