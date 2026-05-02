return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "markdown" },
            highlight = { enable = true },
            indent = { enable = false },
        })
    end,
}
