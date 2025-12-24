return {
    "stevearc/conform.nvim",
    opts = {
    },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = {"stylua"},
                python = {"isort", "black"},
                cpp = {"clang-format"},
                cuda = {'clang-format-cuda'}
            },
        })
    end
}
