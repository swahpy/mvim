require("plugins.treesitter")
require("plugins.mini")
require("plugins.undotree")
require("plugins.lsp")
require("plugins.conform")
require("plugins.codecompanion")

require("config.keymap")
require("config.options")

-- vim.cmd("colorscheme randomhue")
vim.pack.add({ "https://github.com/catppuccin/nvim" })
vim.cmd("colorscheme catppuccin")
