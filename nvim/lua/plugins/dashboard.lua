return {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local dashboard = require("dashboard")

        dashboard.setup({
            theme = "hyper",
            config = {
                header = {
                    "",
                    " ██████╗ █████╗ ███╗   ██╗██╗   ██╗██╗  ██╗",
                    " ██╔══██╗██╔══██╗████╗  ██║██║   ██║╚██╗██╔╝",
                    " ██████╔╝███████║██╔██╗ ██║██║   ██║ ╚███╔╝ ",
                    " ██╔══██╗██╔══██║██║╚██╗██║██║   ██║ ██╔██╗ ",
                    " ██████╔╝██║  ██║██║ ╚████║╚██████╔╝██╔╝ ██╗",
                    " ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝",
                    "",
                },
                center = {
                    {
                        icon = " ",
                        icon_hl = "DashboardIcon",
                        desc = "查找文件",
                        desc_hl = "DashboardDesc",
                        key = "f",
                        keymap = "<leader>ff",
                        key_hl = "DashboardKey",
                        action = "Telescope find_files",
                    },
                    {
                        icon = " ",
                        icon_hl = "DashboardIcon",
                        desc = "查找文本",
                        desc_hl = "DashboardDesc",
                        key = "g",
                        keymap = "<leader>fg",
                        key_hl = "DashboardKey",
                        action = "Telescope live_grep",
                    },
                    {
                        icon = " ",
                        icon_hl = "DashboardIcon",
                        desc = "新建文件",
                        desc_hl = "DashboardDesc",
                        key = "n",
                        keymap = "enew",
                        key_hl = "DashboardKey",
                        action = "enew",
                    },
                    {
                        icon = " ",
                        icon_hl = "DashboardIcon",
                        desc = "更新插件",
                        desc_hl = "DashboardDesc",
                        key = "u",
                        keymap = "<cmd>Lazy sync<cr>",
                        key_hl = "DashboardKey",
                        action = "Lazy sync",
                    },
                    {
                        icon = " ",
                        icon_hl = "DashboardIcon",
                        desc = "退出",
                        desc_hl = "DashboardDesc",
                        key = "q",
                        keymap = "<cmd>qa<cr>",
                        key_hl = "DashboardKey",
                        action = "qa",
                    },
                },
                footer = {
                    "⚡ Neovim " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch,
                },
            },
        })

        vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#55efc4" })
        vim.api.nvim_set_hl(0, "DashboardIcon", { fg = "#48dbfb" })
        vim.api.nvim_set_hl(0, "DashboardKey", { fg = "#a29bfe" })
        vim.api.nvim_set_hl(0, "DashboardDesc", { fg = "#fd79a8" })
        vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#636e72" })
    end,
}
