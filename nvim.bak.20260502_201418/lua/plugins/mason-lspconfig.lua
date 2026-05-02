return {
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPre",
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "clangd", "pyright", "cmake" },
        })
    end,
}