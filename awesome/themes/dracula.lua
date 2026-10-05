-- dracula 配色
--
-- 值取自原 chadwm 的两份配色文件，没有改过：
--   scripts/bar_themes/dracula  → black/white/grey/blue/green/red/darkblue（状态栏药丸用）
--   chadwm/themes/dracula.h     → gray2/gray3（窗口和标签用，bar 那份里没有）
-- 两份文件里同名的键取值略有出入时，一律用 bar 那份 —— 状态栏是看着最久的那个。

return {
  -- 状态栏药丸 / 通用底色与前景
  black    = "#21222c",   -- 底色：状态栏、空标签
  white    = "#f8f8f2",   -- 前景：文字
  grey     = "#282a36",   -- 数值段的底色、聚焦标签底
  blue     = "#d6acff",   -- 主强调色：聚焦边框、时间、聚焦标签文字
  green    = "#50fa7b",   -- CPU
  red      = "#ff5555",   -- 电池、内存、紧急标签
  darkblue = "#bd93f9",   -- 时钟图标底色
  -- 窗口专用
  gray2    = "#282a36",   -- 未聚焦边框
  gray3    = "#44475a",   -- 弱化文字：空标签、最小化的窗口
}
