local o = vim.opt

-- UI
o.relativenumber = true
o.scrolloff = 2
o.winblend = 0


-- editing
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.autoindent = true

o.swapfile = false

-- folding
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
-- o.foldmethod = "indent" -- Set 'indent' folding method
o.foldlevel = 1 -- Display all folds except top ones
o.foldnestmax = 10 -- Create folds only for some number of nested levels
vim.g.markdown_folding = 1   -- Use folding by heading in markdown files
if vim.fn.has "nvim-0.10" == 1 then
  o.foldtext = "" -- Use underlying text with its highlighting
end
