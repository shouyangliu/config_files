return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    pin = true,  -- 锁定版本
    config = function()
        require("todo-comments").setup({
            signs = true,
            keywords = {
                FIX = { icon = " ", color = "error" },
                TODO = { icon = " ", color = "info" },
                HACK = { icon = " ", color = "warning" },
                WARN = { icon = " ", color = "warning" },
                PERF = { icon = " ", color = "hint" },
                NOTE = { icon = " ", color = "hint" },
            },
        })

        vim.keymap.set("n", "]t", function()
            require("todo-comments").jump_next()
        end, { desc = "Next todo comment" })

        vim.keymap.set("n", "[t", function()
            require("todo-comments").jump_prev()
        end, { desc = "Previous todo comment" })
    end,
}
