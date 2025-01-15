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

-- add neotab plugin in here, so that Tab key
-- will function well.
require("mini.deps").add {
  source = "kawre/neotab.nvim",
}
require("neotab").setup()

local imap_expr = function(lhs, rhs)
  map("i", lhs, rhs, { expr = true })
end
imap_expr("<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  else
    return "<Plug>(neotab-out)"
  end
end)
imap_expr("<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

-- Use fuzzy matching for built-in completion
if vim.fn.has "nvim-0.11" == 1 then
  vim.opt.completeopt:append "fuzzy"
end
