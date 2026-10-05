-- everforest 配色
--
-- 值取自原 chadwm 的两份配色文件，没有改过：
--   scripts/bar_themes/everforest  → black/white/grey/blue/green/red/darkblue（状态栏药丸用）
--   chadwm/themes/everforest.h     → gray2/gray3（窗口和标签用，bar 那份里没有）
-- 两份文件里同名的键取值略有出入时，一律用 bar 那份 —— 状态栏是看着最久的那个。

return {
  -- 状态栏药丸 / 通用底色与前景
  black    = "#2b3339",   -- 底色：状态栏、空标签
  white    = "#d3c6aa",   -- 前景：文字
  grey     = "#4e565c",   -- 数值段的底色、聚焦标签底
  blue     = "#7393b3",   -- 主强调色：聚焦边框、时间、聚焦标签文字
  green    = "#a7c080",   -- CPU
  red      = "#e67e80",   -- 电池、内存、紧急标签
  darkblue = "#577b9f",   -- 时钟图标底色
  -- 窗口专用
  gray2    = "#323c41",   -- 未聚焦边框
  gray3    = "#465058",   -- 弱化文字：空标签、最小化的窗口
}
