require("config.basic_setting")
require("config.keymaps")
require("config.lazy")

--background
--vim.cmd "colorscheme catppuccin-mocha" --theme
--vim.cmd "colorscheme tokyonight" --theme
vim.cmd[[colorscheme neon]]
vim.opt.showtabline=2
vim.opt.laststatus=3
vim.opt.termguicolors = true
vim.cmd "hi pmenu ctermfg=black ctermbg=111 guibg=#37b34c" 
vim.cmd "hi pmenusel ctermfg=white ctermbg=61 guibg=#555555 guifg=#ffffff"
vim.cmd "hi normal ctermfg=252 ctermbg=none guibg=none" --背景透明

-- for gui
vim.o.guifont = "comicshannsmono nerd font mono:h16"
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0

-- helper function for transparency formatting
local alpha = function()
  return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
end
-- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
vim.g.neovide_transparency = 0.8
vim.g.transparency = 0.8
vim.g.neovide_background_color = "#0f1117" .. alpha()
-- floating windows
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5
-- hiding the mouse when typing
vim.g.neovide_hide_mouse_when_typing = false
vim.g.neovide_refresh_rate = 60
vim.g.neovide_refresh_rate_idle = 5
-- 输入法
vim.g.neovide_input_ime = true
--动画
vim.g.neovide_cursor_vfx_mode = "pixiedust"

