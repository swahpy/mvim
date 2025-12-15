vim.pack.add({
  "https://github.com/olimorris/codecompanion.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
  file_types = { "markdown", "codecompanion" },
})

local default_model = "gemini-3-pro-preview"

require("codecompanion").setup({
  interactions = {
    chat = {
      adapter = { name = "aiwave", model = default_model },
    },
    inline = {
      adapter = { name = "aiwave", model = default_model },
    },
    cmd = {
      adapter = { name = "aiwave", model = default_model },
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
              desc = "aiwave",
              default = default_model,
              choices = {
                "gemini-pro-latest",
                "gemini-3-pro-preview",
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
