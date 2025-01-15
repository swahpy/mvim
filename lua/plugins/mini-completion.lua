local cmp = require "mini.completion"
local map = vim.keymap.set

cmp.setup {
  window = {
    info = { border = "single" },
    signature = { border = "single" },
  },
  lsp_completion = {
    source_func = "omnifunc",
    auto_setup = false,
  },
  mappings = {
    force_twostep = "<C-t>", -- Force two-step completion
    force_fallback = "<A-f>", -- Force fallback completion
  },
}

-- Use fuzzy matching for built-in completion
if vim.fn.has "nvim-0.11" == 1 then
  vim.opt.completeopt:append "fuzzy"
end

-- select from all available snippets in current context
local rhs = function()
  cmp.expand { match = false }
end
map("i", "<C-g><C-j>", rhs, { desc = "Expand all" })
