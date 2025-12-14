-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = " "
vim.g.maploaclleader = " "

local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

-- my new keymaps
map("i", '<A-">', '""<Left>', opt)
map("i", "<A-'>", "''<Left>", opt)
map("i", "<A-(>", "()<Left>", opt)
map("i", "<A-[>", "[]<Left>", opt)
map("i", "<A-{>", "{}<Left>", opt)
map("i", "<A-<>", "<><Left>", opt)

map("n", "wq", ":wq<CR>", opt)
map("n", "ww", ":w<CR>", opt)
map("n", "qq", ":q<CR>", opt)

map("v", "<", "<gv", opt)
map("v", ">", ">gv", opt)

map("i", "<C-e>", "<End>", opt)
map("i", "<C-h>", "<Home>", opt)
map("i", "<C-n>", "<Right>", opt)
map("i", "<C-p>", "<Left>", opt)
map("i", "jk", "<Esc>", opt)

map("n", "ee", "<End>", opt)
map("n", "eh", "<Home>", opt)
--split

map("n", "sv", ":vsp<CR>", opt)
map("n", "<A-h>", "<C-w>h", opt)
map("n", "<A-j>", "<C-w>j", opt)
map("n", "<A-k>", "<C-w>k", opt)
map("n", "<A-l>", "<C-w>l", opt)
map("n", "<S-t>", ":sp term://$SHELL<CR>", opt)

--resize the window
map("n", "<A-Up>", ":resize -2<CR>", opt)
map("n", "<A-Down>", ":resize +2<CR>", opt)
map("n", "<A-Left>", ":vertical resize -2<CR>", opt)
map("n", "<A-Right>", ":vertical resize +2<CR>", opt)

--nvim-tree
map("n", "<A-t>", ":NvimTreeToggle<CR>", opt)

--float term
map("n", "tt", ":FloatermNew<CR>", opt)

--markdown
--map('n', '<C-p>', ':MarkdownPreview<CR>', opt)

-- coment
map("n", "<A-c>", ":Neogen<CR>", opt)

--bufferline
map("n", "<A-n>", ":bn<CR>", opt)
map("n", "<A-p>", ":bp<CR>", opt)
map("n", "GT", ":b#<CR>", opt)
map("n", "b", ":b", opt)
map("n", "bd", ":bd<CR>", opt)

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        vim.diagnostic.config {
            virtual_text = true,
        }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = event.buf, desc = 'Lsp: Goto Definiton' })
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = event.buf, desc = 'Lsp: Goto Definiton' })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = event.buf, desc = 'Lsp: Goto Definiton' })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = event.buf, desc = 'Lsp: Goto Definiton' })
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, { buffer = event.buf, desc = 'Lsp: Goto Definiton' })
        vim.keymap.set('n', 'gr', vim.lsp.buf.rename, { buffer = event.buf, desc = 'Lsp: Goto Definiton' })
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = event.buf, desc = 'Lsp: Goto Definiton' })
        vim.keymap.set('n', ']D', vim.diagnostic.goto_prev, { buffer = event.buf, desc = 'Lsp: Goto Definiton' })
        vim.keymap.set('n', '<space>f', vim.lsp.buf.format, { buffer = event.buf, desc = 'Lsp: Goto Definiton' })
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float,
            { buffer = event.buf, desc = 'Lsp: Show Line Diagnostic' })
        -- 2. 将诊断信息加入位置列表
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist,
            { buffer = event.buf, desc = 'Lsp: Diagnostic to Loclist' })
        -- 3. 插入模式下显示签名帮助（比如写函数时看参数）
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = event.buf, desc = 'Lsp: Signature Help' })
        -- 4. 跳转到类型定义（比如类/结构体的定义）
        vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, { buffer = event.buf, desc = 'Lsp: Goto Type Definition' })
        -- 5. 工作区相关：添加工作区文件夹
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder,
            { buffer = event.buf, desc = 'Lsp: Add Workspace Folder' })
        -- 6. 工作区相关：移除工作区文件夹
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,
            { buffer = event.buf, desc = 'Lsp: Remove Workspace Folder' })
        -- 7. 工作区相关：列出所有工作区文件夹（终端输出）
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, { buffer = event.buf, desc = 'Lsp: List Workspace Folders' })
        -- 8. 可视化模式下的代码操作（选中代码后执行）
        vim.keymap.set('v', '<space>ca', vim.lsp.buf.code_action, { buffer = event.buf, desc = 'Lsp: Visual Code Action' })
        -- 9. 切换内嵌提示（Neovim 0.10+ 支持，比如显示变量类型）
        vim.keymap.set('n', '<space>ci', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
        end, { buffer = event.buf, desc = 'Lsp: Toggle Inlay Hints' })
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.keymap.set('n', "<space>h", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled{bufnr = event.buf})
        end, {buffer = event.buf, desc = 'Lsp '})
    end
    end,
})
