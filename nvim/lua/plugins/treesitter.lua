return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "c", "cpp", "lua", "vim", "python", "bash" },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
