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

map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit All" })

map("n", "<M-->", "<cmd>term<cr>", { desc = "open terminal" })

map("n", "<leader>x", "<cmd>.lua<cr>", { desc = "execute Lua code in current buffer" })
