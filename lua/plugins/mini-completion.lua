local completion = require "mini.completion"
local opts = { filtersort = "fuzzy" }
local process_items = function(items, base)
  return completion.default_process_items(items, base, opts)
end

completion.setup {
  window = {
    info = { border = "double" },
    signature = { border = "double" },
  },
  lsp_completion = {
    source_func = "omnifunc",
    auto_setup = false,
    lsp_completion = { process_items = process_items },
  },
  mappings = {
    force_twostep = "<C-t>",
    force_fallback = "<A-f>",
  },
}

-- Use fuzzy matching for built-in completion
if vim.fn.has "nvim-0.11" == 1 then
  vim.opt.completeopt:append "fuzzy"
end

-- add icon to completion items
require("mini.icons").tweak_lsp_kind()
