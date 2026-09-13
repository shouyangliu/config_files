local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- 基础设置
config.default_prog = {'/bin/bash'}
config.automatically_reload_config = true
config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.adjust_window_size_when_changing_font_size = false
config.window_close_confirmation = 'NeverPrompt'

-- 环境变量（Fcitx5 输入法支持）
config.set_environment_variables = {
  GTK_IM_MODULE = 'fcitx5',
  QT_IM_MODULE = 'fcitx5',
  XMODIFIERS = '@im=fcitx5',
}

-- 颜色方案
config.color_scheme = 'Dracula'

-- 字体配置
config.font = wezterm.font_with_fallback {
  'JetBrains Mono',
  'ComicShannsMono Nerd Font Mono',
  'Noto Sans Mono CJK SC',
  'Symbols Nerd Font Mono',
}

config.font_size = 12.0
config.line_height = 1.2

-- 窗口设置
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

config.window_background_opacity = 0.85
config.window_decorations = "RESIZE"

-- 标签栏设置
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true
config.tab_max_width = 24
config.status_update_interval = 5

-- 光标设置
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 800
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

-- Leader 键（类似 tmux）
config.leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 1000 }

-- 快捷键配置
config.keys = {
  -- Leader 键相关
  { key = 's', mods = 'LEADER', action = wezterm.action.SendKey { key = 's', mods = 'CTRL' } },
  
  -- 窗格操作
  { key = '/', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },
  
  -- 窗格导航
  { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
  
  -- 窗格大小调整
  { key = 'LeftArrow', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = 'RightArrow', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
  { key = 'UpArrow', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
  { key = 'DownArrow', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
  
  -- 标签页操作
  { key = 'c', mods = 'LEADER', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = '&', mods = 'LEADER|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = true } },
  { key = 'n', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(-1) },
  
  -- 标签页切换
  { key = '1', mods = 'LEADER', action = wezterm.action.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = wezterm.action.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = wezterm.action.ActivateTab(2) },
  { key = '4', mods = 'LEADER', action = wezterm.action.ActivateTab(3) },
  { key = '5', mods = 'LEADER', action = wezterm.action.ActivateTab(4) },
  { key = '6', mods = 'LEADER', action = wezterm.action.ActivateTab(5) },
  { key = '7', mods = 'LEADER', action = wezterm.action.ActivateTab(6) },
  { key = '8', mods = 'LEADER', action = wezterm.action.ActivateTab(7) },
  { key = '9', mods = 'LEADER', action = wezterm.action.ActivateTab(8) },
  
  -- 复制模式
  { key = '[', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },
  
  -- 搜索
  { key = 'f', mods = 'CTRL|SHIFT', action = wezterm.action.Search 'CurrentSelectionOrEmptyString' },
  
  -- 其他快捷键
  { key = 'r', mods = 'CTRL|SHIFT', action = wezterm.action.ReloadConfiguration },
  { key = 'n', mods = 'CTRL|SHIFT', action = wezterm.action.ShowTabNavigator },
  { key = 'z', mods = 'CTRL|SHIFT', action = wezterm.action.TogglePaneZoomState },
  { key = 'p', mods = 'CTRL|SHIFT', action = wezterm.action.QuickSelect },
}

-- 鼠标绑定
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
  {
    event = { Up = { streak = 1, button = 'Middle' } },
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}

-- 超链接规则
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- 状态栏配置
wezterm.on('update-status', function(window, pane)
  local cwd = pane:get_current_working_dir()
  local basename = cwd and wezterm.path.basename(cwd) or ''
  local user = os.getenv('USER') or 'user'
  local hostname = wezterm.info().hostname()
  local date = os.date('%Y-%m-%d %H:%M')
  
  local left = string.format(' %s@%s:%s ', user, hostname, basename)
  local right = string.format(' %s ', date)
  
  window:set_left_status(wezterm.format {
    { Foreground = { Color = '#bd93f9' } },
    { Text = '▋' },
    { Foreground = { Color = '#f8f8f2' } },
    { Text = left },
  })
  
  window:set_right_status(wezterm.format {
    { Foreground = { Color = '#f8f8f2' } },
    { Text = right },
    { Foreground = { Color = '#bd93f9' } },
    { Text = ' ▌' },
  })
end)

-- 标签页标题格式
wezterm.on('format-tab-title', function(tab, tabs, panes, cfg, hover, max_width)
  local index = tab.tab_index + 1 .. ': '
  local pane_title = tab.active_pane.title or ''
  if tab.is_active then
    return {
      { Background = { Color = '#282a36' } },
      { Text = '● ' .. index },
      { Foreground = { Color = '#50fa7b' } },
      { Text = pane_title },
    }
  else
    return {
      { Background = { Color = '#44475a' } },
      { Text = '○ ' .. index },
      { Foreground = { Color = '#8be9fd' } },
      { Text = pane_title },
    }
  end
end)

-- 窗口标题格式
wezterm.on('format-window-title', function(tab, pane, tabs, panes, cfg)
  local title = 'WezTerm'
  if #tabs > 1 then
    title = title .. ' [' .. tab.tab_index + 1 .. '/' .. #tabs .. ']'
  end
  if tab.active_pane.title then
    title = title .. ' - ' .. tab.active_pane.title
  end
  return title
end)

return config