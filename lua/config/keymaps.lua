-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("i", "<C-a>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map({ "n", "x", "v" }, "gb", "^", { desc = "move to beginning character of current line" })
map({ "n", "x", "v" }, "ge", "$", { desc = "move to ending character of current line" })

map({ "n", "v" }, ";", ":", { desc = "CMD enter command mode" })
map({ "n", "i", "v" }, "<A-w>", "<cmd> w <cr><Esc>")

map("n", "<A-->", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })
map("t", "<A-->", "<cmd>close<cr>", { desc = "Close Terminal" })

-- formatting
map({ "n", "v" }, "<M-f>", function()
  LazyVim.format({ force = true })
end, { desc = "Format" })

function _G.center_current_line()
  vim.cmd("normal! zz")
end
map("n", "o", "<cmd>lua center_current_line()<CR>o", { noremap = true })
map("n", "O", "<cmd>lua center_current_line()<CR>O", { noremap = true })
map("n", "i", "<cmd>lua center_current_line()<CR>i", { noremap = true })
map("n", "a", "<cmd>lua center_current_line()<CR>a", { noremap = true })
map("n", "cc", "<cmd>lua center_current_line()<CR>cc", { noremap = true })
map("n", "C", "<cmd>lua center_current_line()<CR>C", { noremap = true })
