vim.g.mapleader = " "

local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

map("i", "<A-'>", "''<Left>", opt)
map("i", '<A-">', '""<Left>', opt)
map("i", "<A-(>", "()<Left>", opt)
map("i", "<A-[>", "[]<Left>", opt)
map("i", "<A-{>", "{}<Left>", opt)

map("n", "jk", "<Esc>", opt)
map("i", "jk", "<Esc>", opt)

map("n", "<leader>w", ":w<CR>", opt)
map("n", "<leader>q", ":q<CR>", opt)

map("n", "<A-t>", ":NvimTreeToggle<CR>", opt)

map("n", "sv", ":vsp<CR>", opt)
map("n", "sh", ":sp<CR>", opt)
map("n", "<A-h>", "<C-w>h", opt)
map("n", "<A-j>", "<C-w>j", opt)
map("n", "<A-k>", "<C-w>k", opt)
map("n", "<A-l>", "<C-w>l", opt)

map("n", "<A-n>", ":bn<CR>", opt)
map("n", "<A-p>", ":bp<CR>", opt)
map("n", "bd", ":bd<CR>", opt)

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
        vim.diagnostic.config({ virtual_text = true })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "Goto Definition" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = event.buf, desc = "Goto References" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf, desc = "Hover" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf, desc = "Code Action" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = event.buf, desc = "Rename" })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = event.buf, desc = "Next Diagnostic" })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = event.buf, desc = "Prev Diagnostic" })
    end,
})
