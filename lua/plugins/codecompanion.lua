vim.pack.add({
  "https://github.com/olimorris/codecompanion.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
  file_types = { "markdown", "codecompanion" },
})

local default_model = "grok-4-auto"

require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "aiwave",
      model = default_model,
    },
    inline = {
      adapter = "aiwave",
      model = default_model,
    },
    cmd = {
      adapter = "aiwave",
      model = default_model,
    },
  },
  adapters = {
    http = {
      aiwave = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          env = {
            api_key = "AIWAVE_API_KEY",
            url = function()
              return os.getenv("AIWAVE_URL")
            end,
          },
          schema = {
            model = {
              order = 1,
              mapping = "parameters",
              type = "enum",
              desc = "ID of the model to use.",
              default = default_model,
              choices = {
                "grok-4-expert",
                "grok-4-auto",
                "gemini-2.5-flash",
                "gemini-2.5-pro",
                "claude-sonnet-4-20250514",
                "gpt-5-high",
              },
            },
            max_tokens = {
              order = 2,
              default = 9999,
            },
          },
        })
      end,
    },
  },
  display = {
    chat = {
      show_settings = false,
    },
  },
})

-- Set up command abbreviations for CodeCompanion
vim.cmd([[cab cc CodeCompanion]])
vim.cmd([[cab ca CodeCompanionActions]])
vim.cmd([[cab ct CodeCompanionChat Toggle]])
vim.cmd([[cab ctc CodeCompanionChat Toggle --continue]])
vim.cmd([[cab cca CodeCompanionChat Add]])
