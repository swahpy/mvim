vim.pack.add({
  "https://github.com/olimorris/codecompanion.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
  file_types = { "markdown", "codecompanion" },
})

require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "aiwave",
      model = "grok-4",
    },
    inline = {
      adapter = "aiwave",
      model = "grok-4",
    },
    cmd = {
      adapter = "aiwave",
      model = "grok-4",
    },
  },
  adapters = {
    http = {
      opts = {
        show_defaults = false,
      },
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
              default = "grok-4",
              choices = { "grok-4", "gemini-2.0-flash", "gemini-2.5-pro", "claude-sonnet-4-20250514", "gpt-5-high" },
            },
            max_tokens = {
              default = 9999,
            },
          },
        })
      end,
    },
  },
  display = {
    chat = {
      show_settings = true,
    },
  },
})

-- Set up command abbreviations for CodeCompanion
vim.cmd([[cab cc CodeCompanion]])
vim.cmd([[cab ca CodeCompanionActions]])
vim.cmd([[cab ct CodeCompanionChat Toggle]])
vim.cmd([[cab ctc CodeCompanionChat Toggle --continue]])
vim.cmd([[cab cca CodeCompanionChat Add]])
