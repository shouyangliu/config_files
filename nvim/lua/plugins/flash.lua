return {
    "folke/flash.nvim",
    event = "VeryLazy",
    pin = true,  -- 锁定版本
    config = function()
        require("flash").setup({
            modes = {
                char = {
                    keys = { "f", "F", "t", "T" },
                    highlight = { backdrop = true },
                },
            },
        })

        -- 快捷键
        vim.keymap.set({ "n", "x", "o" }, "s", function()
            require("flash").jump()
        end, { desc = "Flash" })

        vim.keymap.set({ "n", "x", "o" }, "S", function()
            require("flash").treesitter()
        end, { desc = "Flash Treesitter" })
    end,
}
