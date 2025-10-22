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
map("n", "<leader>Q", "<cmd>copen<cr>", "open quickfix list")

-- Create a global table for quickfix utilities to avoid polluting _G
_G.QuickfixActions = _G.QuickfixActions or {}

-- Define quickfix navigation functions within the global table
function _G.QuickfixActions.next_item()
  local qf_win_id = vim.api.nvim_get_current_win()
  pcall(vim.cmd, "cnext")
  vim.api.nvim_set_current_win(qf_win_id)
end

function _G.QuickfixActions.prev_item()
  local qf_win_id = vim.api.nvim_get_current_win()
  pcall(vim.cmd, "cprevious")
  vim.api.nvim_set_current_win(qf_win_id)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf", -- Change 'markdown' to your desired filetype, e.g., 'lua', 'python'
  callback = function()
    local bufmap = vim.api.nvim_buf_set_keymap
    bufmap(0, "n", "j", "<cmd>lua vim.schedule(QuickfixActions.next_item)<cr>", { noremap = true, silent = true })
    bufmap(0, "n", "k", "<cmd>lua vim.schedule(QuickfixActions.prev_item)<cr>", { noremap = true, silent = true })
    bufmap(0, "n", "c", "<cmd>cexpr<cr>", { noremap = true, silent = true })
    bufmap(0, "n", "q", "<cmd>cclose<cr>", { noremap = true, silent = true })
  end,
})

map("n", "<leader>qq", "<cmd>qa<cr>", "Quit All")

map("n", "<leader>x", "<cmd>.lua<cr>", "execute Lua code in current buffer")

local formatting_cmd = '<Cmd>lua require("conform").format({lsp_fallback=true})<CR>'

map("n", "<leader>la", "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Actions")
map("n", "<leader>ld", "<Cmd>lua vim.diagnostic.open_float()<CR>", "Diagnostic popup")
map("n", "<leader>lf", formatting_cmd, "Format")
map("n", "<leader>li", "<Cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation")
map("n", "<leader>lh", "<Cmd>lua vim.lsp.buf.hover()<CR>", "Hover")
map("n", "<leader>lr", "<Cmd>lua vim.lsp.buf.rename()<CR>", "Rename")
map("n", "<leader>lR", "<Cmd>lua vim.lsp.buf.references()<CR>", "References")
map("n", "<leader>ls", "<Cmd>lua vim.lsp.buf.definition()<CR>", "Source definition")
map("n", "<leader>lt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", "Type definition")

vim.keymap.set("x", "<leader>lf", formatting_cmd, { desc = "Format selection" })

-- command abbreviations
vim.cmd([[cab vpu lua vim.pack.update()]])
