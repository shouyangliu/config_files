return {
    "neovim/nvim-lspconfig",
    config = function()
        -- Setup language servers.
        local lspconfig = require('lspconfig')
        
        -- 禁用语义高亮的配置选项
        local disable_semantic_tokens = {
            semantic_tokens = {
                enable = false,
            },
        }
        -- 这是一个自定义的 root_dir 检测函数
        -- 它会从当前文件所在的目录向上搜索，直到找到 .git 或 build/compile_commands.json 文件
        local util = require("lspconfig.util")
        local root_dir = util.root_pattern(
            ".git",
            "build/compile_commands.json",
            "compile_commands.json"
        )

        -- 为每个语言服务器添加 disable_semantic_tokens
        lspconfig.pyright.setup(disable_semantic_tokens)
        lspconfig.clangd.setup({root_dir = root_dir,})
        lspconfig.cmake.setup(disable_semantic_tokens)
        -- lspconfig.pyright.setup {}
        -- lspconfig.clangd.setup {}
        -- lspconfig.cmake.setup {}
        
        -- Global mappings.
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
        
        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
          callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        
            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set('n', '<space>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<leader>cn', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<leader>f', function()
              vim.lsp.buf.format { async = true }
            end, opts)
          end,
        })
    end
}
