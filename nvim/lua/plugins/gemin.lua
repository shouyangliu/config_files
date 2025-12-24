return {
  "yetone/avante.nvim",
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = vim.fn.has("win32") ~= 0
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- 将 provider 切换为 "gemini"
    provider = "gemini",
    providers = {
      -- 原始的 Claude 配置保持不变
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-20250514",
        timeout = 30000,
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
      },
      -- 原始的 Moonshot 配置保持不变
      moonshot = {
        endpoint = "https://api.moonshot.ai/v1",
        model = "kimi-k2-0711-preview",
        timeout = 30000,
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 32768,
        },
      },
      -- 新增 Gemini 配置
      gemini = {
        model = "gemini-pro",
        endpoint = "https://generativelanguage.googleapis.com/v1beta/models/",
        model = "gemini-2.0-flash",
        -- Google API 的 API 密钥通常通过环境变量 GOOGLE_API_KEY 或 GOOGLE_GEMINI_API_KEY 来获取
        api_key = os.getenv("GEMINI_API_KEY"),
        -- 设置请求超时时间
        timeout = 30000,
        -- 其他可选的配置，例如 temperature
        extra_request_body = {
          generationConfig = {
            temperature = 0.75,
            max_output_tokens = 20480,
          },
        },
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "echasnovski/mini.pick",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "stevearc/dressing.nvim",
    "folke/snacks.nvim",
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/copilot.lua",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
