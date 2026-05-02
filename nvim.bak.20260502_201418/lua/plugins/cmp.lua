return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    },
    config = function()
        local cmp = require("cmp")
        cmp.setup({
            mapping = {
                ["<Tab>"] = cmp.mapping.select_next_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
            }),
        })
    end,
}
