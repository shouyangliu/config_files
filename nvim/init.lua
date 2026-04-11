require("config.basic_setting")
require("config.keymaps")
require("config.lazy")

vim.cmd("colorscheme neon")
vim.opt.showtabline = 2
vim.opt.laststatus = 3
vim.opt.termguicolors = true

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

if vim.g.neovide then
    vim.o.guifont = "ComicShannsMono Nerd Font Mono:h14"
    vim.g.neovide_transparency = 0.85
    vim.g.neovide_background_color = "#0f1117"
    vim.g.neovide_input_ime = true
end
