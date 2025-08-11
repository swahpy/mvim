local map = vim.keymap.set

map("i", "<C-a>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map({ "n", "x", "v" }, "gb", "^", { desc = "move to beginning character of current line" })
map({ "n", "x", "v" }, "ge", "$", { desc = "move to ending character of current line" })

map({ "n", "v" }, ";", ":", { desc = "CMD enter command mode" })
map({ "n", "i", "v" }, "<A-w>", "<cmd> w <cr><Esc>")
map({ "n", "i", "v" }, "<A-q>", "<cmd> wq <cr><Esc>")

-- Move Lines
-- map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
-- map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
-- map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
-- map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
-- map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
-- map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
