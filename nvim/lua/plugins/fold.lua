return {
    "jghauser/fold-cycle.nvim",
    config = function()
        require("fold-cycle").setup({ open_if_max_closed = true })
        vim.keymap.set("n", "<tab>", function() require("fold-cycle").open() end, { silent = true })
        vim.keymap.set("n", "<s-tab>", function() require("fold-cycle").close() end, { silent = true })
    end,
}
