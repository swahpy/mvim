vim.pack.add({
  "https://github.com/milanglacier/minuet-ai.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
})

require("minuet").setup({
  lsp = {
    enabled_ft = { "*" },
    -- Enables automatic completion triggering using `vim.lsp.completion.enable`
    enabled_auto_trigger_ft = { "*" },
  },
  virtualtext = {
    auto_trigger_ft = { "*" },
    keymap = {
      -- accept whole completion
      accept = "<M-f>",
      -- accept one line
      accept_line = "<M-e>",
      -- accept n lines (prompts for number)
      -- e.g. "A-z 2 CR" will accept 2 lines
      accept_n_lines = "<M-n>",
      -- Cycle to prev completion item, or manually invoke completion
      prev = "<M-[>",
      -- Cycle to next completion item, or manually invoke completion
      next = "<M-]>",
      dismiss = "<C-c>",
    },
  },
  provider = "openai_fim_compatible",
  provider_options = {
    openai_fim_compatible = {
      api_key = "DEEPSEEK_API_KEY",
      name = "deepseek",
      optional = {
        max_tokens = 512,
        top_p = 0.9,
      },
    },
  },
})
