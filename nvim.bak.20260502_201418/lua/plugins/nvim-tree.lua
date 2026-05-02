return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("nvim-tree").setup({
            view = { side = "left", width = 35 },
            filters = { dotfiles = false },
            git = { enable = true },
        })
    end,
}
