require("config.basic_setting")
require("config.keymaps")
require("config.lazy")
require("lsp.init")

-- 容器 LSP 管理（可选）
local ok, container = pcall(require, "lsp.container")
if ok then
    vim.api.nvim_create_user_command('LspInstallInContainer', function(opts)
        container.install_lsp_in_container(opts.args)
    end, { nargs = 1 })

    vim.api.nvim_create_user_command('LspStartContainer', function(opts)
        container.start_container_lsp(opts.args)
    end, { nargs = 1 })

    vim.api.nvim_create_user_command('LspStopContainer', function()
        container.stop_container_lsp()
    end, {})
end

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
