--utf8
vim.g.encoding = 'UTF-8'
vim.g.fileencodings= 'UTF-8'
vim.g.termencoding= 'UTF-8'
vim.wo.number = true --显示行号
vim.wo.relativenumber = true --显示相对行号
--最大列数
vim.wo.colorcolumn = "120"
vim.wo.cursorline = true --highlighe the line where you are
--缩进
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4

vim.o.showtabline=2
--对齐
vim.o.expandtab = true
vim.bo.expandtab = true
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true
--大小写不敏感
vim.o.ignorecase = true
vim.o.smartcase = true
--边输入边搜索
vim.o.incsearch = true
vim.o.cmdheight = 2
vim.o.autoread = true
vim.bo.autoread = true
vim.o.backup = false
--vim.o.writbackup = false
vim.o.swapfile = false
vim.o.updatetime = 300
vim.o.timeoutlen = 300
vim.cmd "set showmatch"
vim.cmd "set splitbelow"
vim.cmd "set splitright"
--vim.cmd "set foldmethod=indent" -- fold type
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart=99 -- 默认不折叠
-- vim.o.foldenable = false

--剪贴板
vim.cmd "set clipboard+=unnamedplus"

-----vgit
--vim.o.insearch = false
vim.wo.signcolumn = 'yes'
