return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    pin = true,  -- 锁定版本，避免 API 变更
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = { "c", "cpp", "lua", "vim", "python", "bash" },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
