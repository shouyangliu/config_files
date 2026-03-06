local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Catppuccin Mocha'

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

config.window_background_opacity = 0.9

config.window_decorations = "RESIZE"
config.window_close_confirmation = 'NeverPrompt'
config.adjust_window_size_when_changing_font_size = false

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.tab_max_width = 32

config.enable_scroll_bar = false

config.cursor_blink_rate = 800
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

config.leader = { key = 's', mods = 'CTRL' }

config.keys = {
  { key = 'c', mods = 'LEADER', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = '/', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'w', mods = 'LEADER', action = wezterm.action.CloseCurrentTab { confirm = false } },
  
  { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
  
  { key = 'H', mods = 'LEADER|CTRL', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = 'J', mods = 'LEADER|CTRL', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
  { key = 'K', mods = 'LEADER|CTRL', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
  { key = 'L', mods = 'LEADER|CTRL', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },

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
  local title = tab.tab_index + 1 .. ': '
  if tab.is_active then
    title = '● ' .. title
  else
    title = '○ ' .. title
  end
  title = title .. (tab.active_pane.title or '')
  return title
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
