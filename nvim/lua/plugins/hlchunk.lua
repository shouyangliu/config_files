return {
  "shellRaining/hlchunk.nvim",
  event = { "UIEnter" },
  config = function()
    require("hlchunk").setup({
        indent = {
            chars = { "│", "¦", "┆", "┊", },

            style = {
                { fg = "#37b34c"},
            },
        },
        blank = {
            enable = false,
        }
    })
  end
}
