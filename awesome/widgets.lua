-- 状态栏部件：复刻原 chadwm 的 scripts/bar.sh
--
-- 原来是在 shell 里拼 status2d 转义码（^c$fg^ / ^b$bg^）交给 xsetroot，
-- 这里改成 awesome 原生部件：一个「药丸」= 两段带底色的方块横排，
--   左边 = 图标，底色是该部件的主题色，字色是深色
--   右边 = 数值，底色是灰，字色是浅色
-- 但原 bar.sh 里并非每个部件都是药丸 —— updates 和 mem 是纯文字，下面按原样复刻。
--
-- 不引外部库（vicious 不在 Ubuntu 22.04 源里），全部用内置的 awful.widget.watch。
--
-- 对外只暴露 create()：每个 screen 的 wibar 都要有自己的一份部件实例，
-- 同一个 widget 挂到两个 wibar 上会被抢父节点。

local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")

local M = {}

-- 原 bar.sh 直接调用的字形（都是 Nerd Font 私有区码点，已确认本机字体覆盖）
local ICON_MEM    = "\u{E266}"  --
local ICON_WIFI   = "\u{F0928}" -- 󰤨
local ICON_NOWIFI = "\u{F092D}" -- 󰤭
local ICON_CLOCK  = "\u{F1446}" -- 󱑆
local ICON_UPD    = "\u{F139}"  --

-- 注意这里必须用 {sh, -c, cmd} 的**表**形式。
-- awful.widget.watch 内部走的是 spawn.easy_async（不是 easy_async_with_shell），
-- 而 easy_async 只把字符串交给 g_shell_parse_argv 做分词、**不经过 shell**，
-- 所以管道、通配符、重定向全都不生效。表形式是直接 exec，等于显式起了个 shell。
-- 另外 watch 的默认回调是 widget:set_text(stdout)，stdout 带尾部换行，
-- 会让状态栏多出一行高度，所以下面统一自己写回调去掉首尾空白。
local SH = "/bin/sh"

local function watch(cmd, seconds, callback)
  return awful.widget.watch({ SH, "-c", cmd }, seconds, callback)
end

-- 取命令输出，去掉首尾空白。
-- 外面那层括号不能省：string.gsub 返回两个值（新串 + 替换次数），
-- 不透传的话 tonumber(trim(x)) 会变成 tonumber(串, 次数)，
-- 次数被当成进制 → "bad argument #2 to 'tonumber' (base out of range)"。
local function trim(out)
  return ((out or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

-- 纯文本 textbox。用 set_text 而非 set_markup，字形原样显示。
--
-- 为什么要专门包一层：declarative 语法**不接受裸字符串当孩子**。
-- wibox/widget/base.lua 的 drill() 对每个孩子做 `if not v.is_widget then drill(ids, v)`，
-- 而字符串没有 is_widget 字段，于是被当成声明表去取 .layout，直接报
-- "attempt to index a string value"。所以下面凡是要放字符串的地方都得先包成 widget。
local function text(str)
  local t = wibox.widget.textbox()
  t:set_text(str)
  return t
end

-- 一段带底色的方块。child 既可以传 widget，也可以直接传字符串（自动包成 textbox）
local function block(child, bg, fg)
  if type(child) == "string" then
    child = text(child)
  end
  return {
    { child, widget = wibox.container.margin, left = 8, right = 8, top = 1, bottom = 1 },
    widget = wibox.container.background,
    bg = bg,
    fg = fg,
  }
end

-- 药丸 = 图标块 + 数值块
local function pill(icon, icon_bg, value_cmd, seconds)
  return wibox.widget {
    block(icon, icon_bg, beautiful.pill_bg),
    block(watch(value_cmd, seconds, function(w, out)
      w:set_text(trim(out))
    end), beautiful.pill_grey, beautiful.pill_fg),
    layout = wibox.layout.fixed.horizontal,
  }
end

-- 有没有电池（原 bar.sh 里没电池就整块 return）
local function has_battery()
  local ok, found = pcall(function()
    local f = io.popen("ls -d /sys/class/power_supply/BAT* 2>/dev/null")
    local s = f:read("*a")
    f:close()
    return s
  end)
  return ok and found and found:match("%S") ~= nil
end

function M.create()
  local W = {}

  -- CPU：负载均值。" CPU" 是纯文字标签不是字形（原 bar.sh 就这样）
  W.cpu = pill(" CPU", beautiful.pill_green, "grep -o '^[^ ]*' /proc/loadavg", 2)

  -- 电池：无电池时不创建，rc.lua 里按 nil 跳过
  if has_battery() then
    W.battery = pill(" BAT", beautiful.pill_red,
      "cat /sys/class/power_supply/BAT*/capacity 2>/dev/null", 30)
  end

  -- 内存：原 bar.sh 里是黑底红字 + 字形，数值和字形同处一块底色，不单独打底。
  -- background 的 fg 会传给孩子 textbox，所以不用逐个设色。
  W.mem = wibox.widget {
    {
      text(ICON_MEM),
      watch("free -h | awk '/^Mem/ {print $3}' | sed s/i//g", 5, function(w, out)
        w:set_text(trim(out))
      end),
      layout = wibox.layout.fixed.horizontal,
    },
    widget = wibox.container.background,
    bg = beautiful.pill_bg,
    fg = beautiful.pill_red,
  }

  -- 无线：图标和文字要一起变，所以用一个 watcher 同时更新两个 textbox
  local wifi_icon = wibox.widget.textbox()
  local wifi_text = wibox.widget.textbox()
  watch("cat /sys/class/net/wl*/operstate 2>/dev/null", 5, function(_, out)
    local state = trim(out)
    if state == "up" then
      wifi_icon:set_text(ICON_WIFI)
      wifi_text:set_text("Connected")
    elseif state == "down" then
      wifi_icon:set_text(ICON_NOWIFI)
      wifi_text:set_text("Disconnected")
    else
      -- 没有无线网卡时原 bar.sh 的 case 不匹配，什么都不打印
      wifi_icon:set_text("")
      wifi_text:set_text("")
    end
  end)
  W.wlan = wibox.widget {
    block(wifi_icon, beautiful.pill_blue, beautiful.pill_bg),
    block(wifi_text, beautiful.pill_bg, beautiful.pill_blue),
    layout = wibox.layout.fixed.horizontal,
  }

  -- 时钟：字形深蓝底、时间蓝底
  W.clock = wibox.widget {
    block(ICON_CLOCK, beautiful.pill_darkblue, beautiful.pill_bg),
    block(watch("date '+%H:%M'", 5, function(w, out)
      w:set_text(trim(out))
    end), beautiful.pill_blue, beautiful.pill_bg),
    layout = wibox.layout.fixed.horizontal,
  }

  -- 可升级包数：原 bar.sh 是纯文字（无底色），0 时绿色文案、非 0 时白色。
  -- 原脚本的 `timeout 20` 是 apt 卡住时兜底，保留。
  W.updates = wibox.widget {
    watch("{ timeout 20 apt list --upgradable 2>/dev/null || true; } | tail -n +2 | wc -l",
      3600,
      function(w, out)
        local n = tonumber(trim(out)) or 0
        if n == 0 then
          w:set_markup('<span foreground="' .. beautiful.pill_green .. '">  '
            .. ICON_UPD .. " Fully Updated</span>")
        else
          w:set_markup('<span foreground="' .. beautiful.pill_fg .. '">  '
            .. ICON_UPD .. " " .. n .. " updates</span>")
        end
      end),
    widget = wibox.container.margin,
    left = 8, right = 8, top = 1, bottom = 1,
  }

  return W
end

return M
