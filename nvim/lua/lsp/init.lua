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
