local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end


config.default_prog = {'/bin/bash'}

config.set_environment_variables = {
  GTK_IM_MODULE = 'fcitx5',
  QT_IM_MODULE = 'fcitx5',
  XMODIFIERS = '@im=fcitx5',
}

config.color_scheme = 'Dracula'

config.font = wezterm.font_with_fallback {
  'JetBrains Mono',
  'ComicShannsMono Nerd Font Mono',
  'Noto Sans Mono CJK SC',
  'Symbols Nerd Font Mono',
}

config.font_size = 12
config.line_height = 1.2

config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

config.window_background_opacity = 0.85
config.window_decorations = "RESIZE"
config.window_close_confirmation = 'NeverPrompt'
config.adjust_window_size_when_changing_font_size = false

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true
config.tab_max_width = 24
config.status_update_interval = 1

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

config.enable_scroll_bar = false

config.cursor_blink_rate = 800
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

config.keys = {
  -- Ctrl+/ 左右分屏
  { key = '/', mods = 'CTRL', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  -- Ctrl+- 上下分屏
  { key = '-', mods = 'CTRL', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  -- Ctrl+n 新建标签页
  { key = 'n', mods = 'CTRL', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  -- Ctrl+Shift+q 关闭窗格
  { key = 'q', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentPane { confirm = false } },
  -- Ctrl+Shift+w 关闭标签页
  { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = false } },
  
  -- Alt+hjkl 导航窗格
  { key = 'h', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Right' },
  
  -- Ctrl+Shift+<>+- 调整窗格大小
  { key = '>', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
  { key = '<', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = '+', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
  { key = '-', mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },

  -- Ctrl+1~9 切换标签页
  { key = '1', mods = 'CTRL', action = wezterm.action.ActivateTab(0) },
  { key = '2', mods = 'CTRL', action = wezterm.action.ActivateTab(1) },
  { key = '3', mods = 'CTRL', action = wezterm.action.ActivateTab(2) },
  { key = '4', mods = 'CTRL', action = wezterm.action.ActivateTab(3) },
  { key = '5', mods = 'CTRL', action = wezterm.action.ActivateTab(4) },
  { key = '6', mods = 'CTRL', action = wezterm.action.ActivateTab(5) },
  { key = '7', mods = 'CTRL', action = wezterm.action.ActivateTab(6) },
  { key = '8', mods = 'CTRL', action = wezterm.action.ActivateTab(7) },
  { key = '9', mods = 'CTRL', action = wezterm.action.ActivateTab(8) },

  { key = 'Tab', mods = 'CTRL', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
  
  { key = 'n', mods = 'CTRL|SHIFT', action = wezterm.action.ShowTabNavigator },
  { key = 'r', mods = 'CTRL|SHIFT', action = wezterm.action.ReloadConfiguration },
  
  { key = 'f', mods = 'CTRL|SHIFT', action = wezterm.action.Search 'CurrentSelectionOrEmptyString' },
}

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

config.hyperlink_rules = wezterm.default_hyperlink_rules()

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
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

wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
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
