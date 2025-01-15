require("mini.completion").setup {
  window = {
    info = { border = "double" },
    signature = { border = "double" },
  },
  lsp_completion = {
    source_func = "omnifunc",
    auto_setup = false,
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
