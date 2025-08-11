local o = vim.opt

o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

o.autowrite = true -- Enable auto write

o.tabstop = 2 -- Number of spaces tabs count for
o.shiftwidth = 2 -- Size of an indent
o.shiftround = true -- Round indent
o.expandtab = true -- Use spaces instead of tabs
o.softtabstop = 2
o.autoindent = true

o.swapfile = false

o.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

o.foldmethod = "indent"

o.relativenumber = true
