-- nord 配色
--
-- 值取自原 chadwm 的两份配色文件，没有改过：
--   scripts/bar_themes/nord  → black/white/grey/blue/green/red/darkblue（状态栏药丸用）
--   chadwm/themes/nord.h     → gray2/gray3（窗口和标签用，bar 那份里没有）
-- 两份文件里同名的键取值略有出入时，一律用 bar 那份 —— 状态栏是看着最久的那个。

return {
  -- 状态栏药丸 / 通用底色与前景
  black    = "#2E3440",   -- 底色：状态栏、空标签
  white    = "#D8DEE9",   -- 前景：文字
  grey     = "#373d49",   -- 数值段的底色、聚焦标签底
  blue     = "#81A1C1",   -- 主强调色：聚焦边框、时间、聚焦标签文字
  green    = "#A3BE8C",   -- CPU
  red      = "#BF616A",   -- 电池、内存、紧急标签
  darkblue = "#7292b2",   -- 时钟图标底色
  -- 窗口专用
  gray2    = "#3B4252",   -- 未聚焦边框
  gray3    = "#606672",   -- 弱化文字：空标签、最小化的窗口
}
