-- awesome 主题：catppuccin
--
-- 配色沿用原 chadwm 的 scripts/bar_themes/catppuccin，保证观感延续。
--
-- 做法是「继承官方默认主题再覆盖」：默认主题里定义了布局图标等资源路径
-- （theme.layout_tile 之类），不继承的话 layoutbox 会没有图标。
-- 若这个 dofile 继承法在 4.3 上不成立，退路是直接把
-- /usr/share/awesome/themes/default/theme.lua 拷进来改。

local gears = require("gears")

local theme = dofile(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- 字体：名字必须与 fc-list 的 family 逐字一致。
-- 本机可用的只有 ComicShannsMono 这一族（Nerd Font 版，带图标字形）。
theme.font = "ComicShannsMono Nerd Font 10"

-- 壁纸交给 autostart 里的 feh 随机换（原 chadwm run.sh 的做法）。
-- 官方默认主题里设了 theme.wallpaper = .../default/background.png，
-- 不清掉的话 rc.lua 的 set_wallpaper 会用它盖住 feh。
theme.wallpaper = nil

-- catppuccin 色板
local black    = "#1E1D2D"
local green    = "#ABE9B3"
local white    = "#D9E0EE"
local grey     = "#282737"
local blue     = "#96CDFB"
local red      = "#F28FAD"
local darkblue = "#83bae8"
local gray3    = "#585767"

-- 窗口边框
theme.border_width  = 2
theme.border_normal = grey
theme.border_focus  = blue
theme.border_marked = red

-- 标题栏
theme.titlebar_bg_normal = black
theme.titlebar_bg_focus  = grey
theme.titlebar_fg_normal = white
theme.titlebar_fg_focus  = blue

-- 任务栏（wibar）
theme.wibar_bg     = black
theme.wibar_fg     = white
theme.wibar_height = 26
theme.wibar_border_color = black

-- 窗口间隙（对应原 dwm 的 vanitygaps）
theme.useless_gap = 6

-- 标签页（tag）
theme.taglist_bg_empty    = black
theme.taglist_fg_empty    = gray3
theme.taglist_bg_occupied = black
theme.taglist_fg_occupied = white
theme.taglist_bg_focus    = grey
theme.taglist_fg_focus    = blue
theme.taglist_bg_urgent   = red
theme.taglist_fg_urgent   = black
theme.taglist_spacing     = 1

-- 任务列表
theme.tasklist_bg_normal = black
theme.tasklist_fg_normal = white
theme.tasklist_bg_focus  = black
theme.tasklist_fg_focus  = blue
theme.tasklist_bg_minimize = black
theme.tasklist_fg_minimize = gray3

-- 菜单 / 提示框
theme.menu_bg_normal = grey
theme.menu_fg_normal = white
theme.menu_bg_focus  = blue
theme.menu_fg_focus  = black
theme.menu_border_color = blue
theme.menu_border_width = 1
theme.menu_height = 20
theme.menu_width  = 180

-- 通知
theme.notification_bg     = grey
theme.notification_fg     = white
theme.notification_border_color = blue
theme.notification_border_width = 1

-- 下面的自定义键供 widgets.lua 读取，不是 awesome 内置字段
theme.pill_fg       = white  -- 药丸里数值文字的颜色
theme.pill_bg       = black  -- 药丸里图标文字的颜色（正好与底色相反）
theme.pill_grey     = grey   -- 数值段的底色
theme.pill_green    = green
theme.pill_blue     = blue
theme.pill_red      = red
theme.pill_darkblue = darkblue

return theme
