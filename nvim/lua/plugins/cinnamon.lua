return {
  "declancm/cinnamon.nvim",
  version = "*", -- use latest release
  opts = {
    -- change default options here
  },
  config = function()
    require("cinnamon").setup {
    -- Enable all provided keymaps
    keymaps = {
        basic = true,
        extra = true,
    },
    -- Only scroll the window
    options = { mode = "window" },
}
  end
}
