return {
    "williamboman/mason.nvim",
    dependencies = { 
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    },
    config = function()
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            },

            -- github = {
                ---@since 1.0.0
                -- The template URL to use when downloading assets from GitHub.
                -- The placeholders are the following (in order):
                -- 1. The repository (e.g. "rust-lang/rust-analyzer")
                -- 2. The release version (e.g. "v0.3.0")
                -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
                -- download_url_template = "https://hub.nuaa.cf/%s/releases/download/%s/%s",
            -- },
        })
        -- mason-lspconfig uses the `lspconfig` server names in the APIs it exposes - not `mason.nvim` package names
        -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
        require("mason-lspconfig").setup({
          -- 确保安装，根据需要填写
          ensure_installed = {
            "clang-format",
            "clangd",
            "pyright",
            "cmake-language-server",
            "jsonls",
            "html",
            "yamlls",
            "bashls",
          },
        })
        
        -- 一定要在前面先加载上
        local lspconfig = require('lspconfig')
        
        require("mason-lspconfig").setup_handlers({
          function (server_name)
        --    require("lspconfig")[server_name].setup{}
          end,
          -- Next, you can provide targeted overrides for specific servers.
          ["clangd"] = function ()
            lspconfig.clangd.setup {
              cmd = {
                "clangd",
                "--header-insertion=never",
                "--query-driver=/opt/homebrew/opt/llvm/bin/clang",
                "--all-scopes-completion",
                "--completion-style=detailed",
              }
            }
          end
        })
    end
}
