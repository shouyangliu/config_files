return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
        { ";d", "<cmd>Telescope lsp_definitions<cr>", desc = "Definitions" },
        { ";r", "<cmd>Telescope lsp_references<cr>", desc = "References" },
    },
    config = function()
        local telescope = require("telescope")
        telescope.setup({ defaults = { file_ignore_patterns = { "node_modules", ".git" } } })
    end,
}
