local o = vim.opt

o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

o.autowrite = true -- Enable auto write

o.tabstop = 2 -- Number of spaces tabs count for
o.shiftwidth = 2 -- Size of an indent
o.softtabstop = 2
o.shiftround = true -- Round indent
o.autoindent = true
o.preserveindent = true
o.smartindent = true
o.expandtab = true -- Use spaces instead of tabs

o.swapfile = false

o.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

o.foldmethod = "indent"
o.foldlevel = 99

o.relativenumber = true

o.mousescroll = "ver:15,hor:6"

o.formatoptions = "rqnl1j"

o.iskeyword = "@,48-57,_,192-255,-" -- Treat dash separated words as a word text object

o.completeopt = 'menuone,noselect,fuzzy,nosort'

vim.o.listchars = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:  ' }, ',') -- Special text symbols

if vim.fn.has("nvim-0.12") == 1 then
  vim.o.completefuzzycollect = "keyword,files,whole_line" -- Use fuzzy matching when collecting candidates
  require("vim._extui").enable({ enable = true })
  vim.keymap.set("c", "<Up>", "<C-u><Up>")
  vim.keymap.set("c", "<Down>", "<C-u><Down>")
end
