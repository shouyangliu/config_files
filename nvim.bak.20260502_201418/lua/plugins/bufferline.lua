return {
    "romgrk/barbar.nvim",
    dependencies = {
        "lewis6991/gitsigns.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("barbar").setup({
            icons = { buffer_index = true },
            insert_at_start = true,
        })
    end,
}
