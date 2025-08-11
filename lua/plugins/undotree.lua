vim.pack.add({ "https://github.com/mbbill/undotree" })

vim.g.undotree_ShortIndicators = 1
vim.g.undotree_DiffAutoOpen = 0
vim.g.undotree_SetFocusWhenToggle = 1

vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle undo tree" })
