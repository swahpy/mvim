local o = vim.opt

-- UI
vim.go.number = true
vim.go.relativenumber = true
o.scrolloff = 2
o.winblend = 0
o.wrap = true

-- editing
o.tabstop = 4
o.shiftwidth = 2
o.expandtab = true
o.autoindent = true

o.swapfile = false

-- folding
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
-- o.foldmethod = "indent" -- Set 'indent' folding method
o.foldlevel = 99 -- Display all folds except top ones
o.foldnestmax = 10 -- Create folds only for some number of nested levels
vim.g.markdown_folding = 1 -- Use folding by heading in markdown files
if vim.fn.has "nvim-0.10" == 1 then
  o.foldtext = "" -- Use underlying text with its highlighting
end

-- behaviors
o.clipboard = "unnamedplus"
