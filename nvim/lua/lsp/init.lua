-- Neovim 0.12 原生 LSP 配置

-- Lua LSP
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = { library = vim.api.nvim_get_runtime_file('', true) },
      telemetry = { enable = false },
    },
  },
})

-- C/C++ LSP
vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
})

-- Python LSP
vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
})

-- CMake LSP
vim.lsp.config('cmake', {
  cmd = { 'cmake-language-server' },
  filetypes = { 'cmake' },
})

-- 启用 LSP 服务器
vim.lsp.enable({ 'lua_ls', 'clangd', 'pyright', 'cmake' })

-- LSP 附加时的配置
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- 语义高亮在 Neovim 0.12+ 会自动启用，无需手动调用
  end,
})
