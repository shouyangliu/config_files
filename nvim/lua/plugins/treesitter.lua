return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
        ensure_installed = { "c", "cpp", "lua", "vim", "python", "bash" },
    },
    config = function(_, opts)
        require("nvim-treesitter").setup({})
        require("nvim-treesitter").install(opts.ensure_installed)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "c", "cpp", "lua", "vim", "python", "bash", "javascript", "typescript", "json", "yaml", "html", "css", "markdown" },
            callback = function()
                vim.treesitter.start()
            end,
        })
    end,
}
