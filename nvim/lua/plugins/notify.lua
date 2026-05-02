return {
    "rcarriga/nvim-notify",
    config = function()
        require("notify").setup({
            timeout = 3000,
            max_width = 50,
            stages = "fade_in_slide_out",
        })
        vim.notify = require("notify")
    end,
}
