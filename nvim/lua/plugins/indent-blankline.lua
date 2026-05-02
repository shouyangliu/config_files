return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",
    pin = true,  -- 锁定版本，避免 API 变更
    config = function()
        local highlights = {
            "RainbowGreen",
            "RainbowBlue",
            "RainbowViolet",
            "RainbowCyan",
            "RainbowRed",
            "RainbowYellow",
            "RainbowOrange",
        }

        local highlight_colors = {
            "#55efc4",
            "#48dbfb",
            "#a29bfe",
            "#fd79a8",
            "#ff6b6b",
            "#feca57",
            "#ff9ff3",
        }

        for i, color in ipairs(highlight_colors) do
            vim.api.nvim_set_hl(0, highlights[i], { fg = color, nocombine = true })
        end

        require("ibl").setup({
            indent = {
                highlight = highlights,
                char = "│",
            },
            whitespace = {
                remove_blankline_trail = false,
            },
            scope = {
                enabled = true,
                highlight = "RainbowBlue",
            },
            exclude = {
                filetypes = {
                    "dashboard",
                    "NvimTree",
                    "TelescopePrompt",
                    "help",
                    "terminal",
                    "packer",
                    "lspinfo",
                    "checkhealth",
                },
            },
        })
    end,
}
