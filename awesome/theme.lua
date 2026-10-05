-- awesome 主题：结构（字体 / 边框 / 间隙 / 尺寸）+ 一行开关
--
-- 配色**不在这个文件里** —— 每种配色是 themes/ 下的一个调色板文件，
-- 换主题只改下面那行 THEME，再 Super+Shift+R 热重载。
--
-- 为什么不用 awesome 自带的主题（default / gtk / sky / xresources / zenburn）：
-- 那几套配的是官方默认外观（标题栏、任务栏），都没有状态栏药丸用的那几个色键，
-- 套上去药丸会没颜色。所以配色自己带一份，8 套是从原 chadwm 搬过来的。

local gears = require("gears")

-- ★★★ 换主题就改这一行 ★★★
-- 可选：catppuccin / dracula / everforest / gruvchad / nord / onedark / tokyonight / tundra
local THEME = "catppuccin"

local confdir = gears.filesystem.get_configuration_dir()

-- 做法是「继承官方默认主题再覆盖」：默认主题里定义了布局图标等资源路径
-- （theme.layout_tile 之类），不继承的话 layoutbox 会没有图标。
-- 若这个 dofile 继承法在 4.3 上不成立，退路是直接把
-- /usr/share/awesome/themes/default/theme.lua 拷进来改。
local theme = dofile(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- 调色板。路径走 ~/.config/awesome/（get_configuration_dir 返回的就是软链接后的路径），
-- 符合仓库「配置里只用 ~/.config/xxx」的约定。
local palette_path = confdir .. "themes/" .. THEME .. ".lua"
if not gears.filesystem.file_readable(palette_path) then
  error("theme.lua: 找不到配色文件 " .. palette_path
        .. "（THEME 这个词写错了？可选值见 awesome/themes/ 目录）")
end
local c = dofile(palette_path)

-- 字体：名字必须与 fc-list 的 family 逐字一致。
-- 本机可用的只有 ComicShannsMono 这一族（Nerd Font 版，带图标字形）。
theme.font = "ComicShannsMono Nerd Font 10"

-- 壁纸交给 autostart 里的 feh 随机换（原 chadwm run.sh 的做法）。
-- 官方默认主题里设了 theme.wallpaper = .../default/background.png，
-- 不清掉的话 rc.lua 的 set_wallpaper 会用它盖住 feh。
theme.wallpaper = nil

-- 窗口边框。
-- border_normal 用 gray2 而不是 grey：gray2 才是原 chadwm 画未聚焦边框的颜色
-- （catppuccin 下两者同值 #282737，换别的主题才会看出差别）。
theme.border_width  = 2
theme.border_normal = c.gray2
theme.border_focus  = c.blue
theme.border_marked = c.red

-- 标题栏
theme.titlebar_bg_normal = c.black
theme.titlebar_bg_focus  = c.grey
theme.titlebar_fg_normal = c.white
theme.titlebar_fg_focus  = c.blue

-- 任务栏（wibar）
theme.wibar_bg     = c.black
theme.wibar_fg     = c.white
theme.wibar_height = 26
theme.wibar_border_color = c.black

-- 窗口间隙（对应原 dwm 的 vanitygaps）
theme.useless_gap = 6

-- 标签页（tag）
theme.taglist_bg_empty    = c.black
theme.taglist_fg_empty    = c.gray3
theme.taglist_bg_occupied = c.black
theme.taglist_fg_occupied = c.white
theme.taglist_bg_focus    = c.grey
theme.taglist_fg_focus    = c.blue
theme.taglist_bg_urgent   = c.red
theme.taglist_fg_urgent   = c.black
theme.taglist_spacing     = 1

-- 任务列表
theme.tasklist_bg_normal = c.black
theme.tasklist_fg_normal = c.white
theme.tasklist_bg_focus  = c.black
theme.tasklist_fg_focus  = c.blue
theme.tasklist_bg_minimize = c.black
theme.tasklist_fg_minimize = c.gray3

-- 菜单 / 提示框
theme.menu_bg_normal = c.grey
theme.menu_fg_normal = c.white
theme.menu_bg_focus  = c.blue
theme.menu_fg_focus  = c.black
theme.menu_border_color = c.blue
theme.menu_border_width = 1
theme.menu_height = 20
theme.menu_width  = 180

-- 通知
theme.notification_bg     = c.grey
theme.notification_fg     = c.white
theme.notification_border_color = c.blue
theme.notification_border_width = 1

-- 下面的自定义键供 widgets.lua 读取，不是 awesome 内置字段。
-- 名字对应原 bar.sh 里的 shell 变量（^b$green^ 之类），
-- pill_bg 是药丸里图标文字的颜色，正好与底色相反。
theme.pill_fg       = c.white
theme.pill_bg       = c.black
theme.pill_grey     = c.grey
theme.pill_green    = c.green
theme.pill_blue     = c.blue
theme.pill_red      = c.red
theme.pill_darkblue = c.darkblue

return theme
