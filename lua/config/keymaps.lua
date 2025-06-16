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

map("n", "i", "zzi", { desc = "center screen current line in insert mode" })
map("n", "I", "zzI", { desc = "center screen current line in insert mode" })
map("n", "a", "zza", { desc = "center screen current line in insert mode" })
map("n", "A", "zzA", { desc = "center screen current line in insert mode" })
map("n", "cc", "zzcc", { desc = "center screen current line in insert mode" })
map("n", "C", "zzC", { desc = "center screen current line in insert mode" })
