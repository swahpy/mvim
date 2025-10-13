local map = vim.keymap.set

map("i", "<C-a>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map({ "n", "x", "v" }, "gb", "^", { desc = "move to beginning character of current line" })
map({ "n", "x", "v" }, "ge", "$", { desc = "move to ending character of current line" })

map({ "n", "v" }, ";", ":", { desc = "CMD enter command mode" })
map({ "n", "i", "v" }, "<A-w>", "<cmd> w <cr><Esc>")
map({ "n", "i", "v" }, "<A-q>", "<cmd> wq <cr><Esc>")

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

map("n", "c", '"_c', { desc = "change without yanking" })
map("n", "C", '"_C', { desc = "change without yanking" })
map("i", "<C-o>", "<C-x><C-o>", { desc = "Omni completion" })
map("i", "<C-c>", "<C-x><C-z>", { desc = "stop completion" })

-- keymaps for quickfix operations
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "open quickfix list" })
map("n", "<leader>qn", "<cmd>cnext<cr>", { desc = "jump to next quickfix item" })
map("n", "<leader>qp", "<cmd>cprevious<cr>", { desc = "jump to previous quickfix item" })
map("n", "<leader>qx", "<cmd>cclose<cr>", { desc = "close quickfix list" })
map("n", "<leader>qc", "<cmd>cexpr []<cr>", { desc = "clear quickfix list" })

map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

map("n", "<leader>x", "<cmd>.lua<cr>", { desc = "execute Lua code in current buffer" })

-- command abbreviations
vim.cmd([[cab vpu lua vim.pack.update()]])
