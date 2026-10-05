-- onedark 配色
--
-- 值取自原 chadwm 的两份配色文件，没有改过：
--   scripts/bar_themes/onedark  → black/white/grey/blue/green/red/darkblue（状态栏药丸用）
--   chadwm/themes/onedark.h     → gray2/gray3（窗口和标签用，bar 那份里没有）
-- 两份文件里同名的键取值略有出入时，一律用 bar 那份 —— 状态栏是看着最久的那个。

return {
  -- 状态栏药丸 / 通用底色与前景
  black    = "#1e222a",   -- 底色：状态栏、空标签
  white    = "#abb2bf",   -- 前景：文字
  grey     = "#282c34",   -- 数值段的底色、聚焦标签底
  blue     = "#7aa2f7",   -- 主强调色：聚焦边框、时间、聚焦标签文字
  green    = "#7eca9c",   -- CPU
  red      = "#d47d85",   -- 电池、内存、紧急标签
  darkblue = "#668ee3",   -- 时钟图标底色
  -- 窗口专用
  gray2    = "#2e323a",   -- 未聚焦边框
  gray3    = "#545862",   -- 弱化文字：空标签、最小化的窗口
}
