return {
    'nvim-treesitter/nvim-treesitter',
    config = function() 
	-- for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
  	-- 	--config.install_info.url = config.install_info.url:gsub("https://github.com/", "https://hub.yzuu.cf/")
	-- end
        require'nvim-treesitter.configs'.setup {
            -- A list of parser names, or "all" (the five listed parsers should always be installed)
            ensure_installed = { "cpp", "lua", "vim", "c", "cmake", "python", "lua" },

            -- Install parsers synchronously (only applied to `ensure_installed`)

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally

            -- List of parsers to ignore installing (or "all")

            ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
            -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
            rainbow = {
                enable = true,
                extened_mode = true,
                max_file_lines = nil,
                colors = {
                    "#cc241d",
                    "#a89984",
                    "#b16286",
                    "#d79921",
                    "#689d6a",
                    "#d65d0e",
                    "#458588",
                },
                termcolors = {
                    "Red",
                    "Green",
                    "Yellow",
                    "Blue",
                    "Magenta",
                    "Cyan",
                    "White",
                },
            },
        }
    end
}
