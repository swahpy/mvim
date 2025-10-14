-- a helper to create a Normal mode mapping
local map = function(mode, lhs, rhs, desc)
  -- See `:h vim.keymap.set()`
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

map("i", "<C-a>", "<ESC>^i", "move beginning of line")
map("i", "<C-e>", "<End>", "move end of line")
map({ "n", "x", "v" }, "gb", "^", "move to beginning character of current line")
map({ "n", "x", "v" }, "ge", "$", "move to ending character of current line")

map({ "n", "v" }, ";", ":", "CMD enter command mode")
map({ "n", "i", "v" }, "<A-w>", "<cmd> w <cr><Esc>")
map({ "n", "i", "v" }, "<A-q>", "<cmd> wq <cr><Esc>")

map("n", "<S-h>", "<cmd>bprevious<cr>", "Prev Buffer")
map("n", "<S-l>", "<cmd>bnext<cr>", "Next Buffer")
map("n", "<leader>bs", function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end, "Scratch Buffer")

map("n", "c", '"_c', "change without yanking")
map("n", "C", '"_C', "change without yanking")
map("i", "<C-o>", "<C-x><C-o>", "Omni completion")
map("i", "<C-c>", "<C-x><C-z>", "stop completion")

-- Paste linewise before/after current line
-- Usage: `yiw` to yank a word and `]p` to put it on the next line.
map("n", "[p", '<Cmd>exe "put! " . v:register<CR>', "Paste Above")
map("n", "]p", '<Cmd>exe "put "  . v:register<CR>', "Paste Below")

-- keymaps for quickfix operations
map("n", "<leader>qo", "<cmd>copen<cr>", "open quickfix list")
map("n", "<leader>qn", "<cmd>cnext<cr>", "jump to next quickfix item")
map("n", "<leader>qp", "<cmd>cprevious<cr>", "jump to previous quickfix item")
map("n", "<leader>qx", "<cmd>cclose<cr>", "close quickfix list")
map("n", "<leader>qc", "<cmd>cexpr []<cr>", "clear quickfix list")

map("n", "<leader>qq", "<cmd>qa<cr>", "Quit All")

map("n", "<leader>x", "<cmd>.lua<cr>", "execute Lua code in current buffer")

-- command abbreviations
vim.cmd([[cab vpu lua vim.pack.update()]])
