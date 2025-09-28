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
      adapter = "openai_compatible",
      model = "grok-4",
    },
    inline = {
      adapter = "openai_compatible",
      model = "grok-4",
    },
    cmd = {
      adapter = "openai_compatible",
      model = "grok-4",
    },
  },
  adapters = {
    http = {
      opts = {
        show_defaults = false,
      },
      openai_compatible = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          env = {
            api_key = "AIWAVE_API_KEY",
            url = function()
              return os.getenv("AIWAVE_URL")
            end,
          },
          schema = {
            model = {
              default = function()
                return "grok-4"
              end,
            },
          },
        })
      end,
    },
  },
})

-- Set up command abbreviations for CodeCompanion
vim.cmd([[cab cc CodeCompanion]])
vim.cmd([[cab ca CodeCompanionActions]])
vim.cmd([[cab ct CodeCompanionChat Toggle]])
vim.cmd([[cab ctc CodeCompanionChat Toggle --continue]])
vim.cmd([[cab cca CodeCompanionChat Add]])
