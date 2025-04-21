local map = vim.keymap.set
local capabilities = vim.lsp.protocol.make_client_capabilities()
local completion = require "mini.completion"
capabilities = vim.tbl_deep_extend("force", capabilities, completion.get_lsp_capabilities())
require("zk").setup {
  picker = "minipick",
  lsp = {
    -- `config` is passed to `vim.lsp.start_client(config)`
    config = {
      cmd = { "zk", "lsp" },
      name = "zk",
      capabilities = capabilities,
    },

    -- automatically attach buffers in a zk notebook that match the given filetypes
    auto_attach = {
      enabled = true,
      filetypes = { "markdown" },
    },
  },
}
map(
  "n",
  "<leader>zj",
  [[<cmd> ZkNew {dir = "journal", group = "journal", edit = true} <cr>]],
  { desc = "zk creates journal for today" }
)
map("v", "<leader>zc", function()
  local command = "'<,'>ZkNewFromTitleSelection {dir = 'notes'}"
  vim.cmd(command)
end, { desc = "zk creates a note using selection as title" })
map("v", "<leader>zC", function()
  local title = vim.fn.input "Title: "
  local command = "'<,'>ZkNewFromContentSelection {dir = 'notes', title='" .. title .. "'}"
  vim.cmd(command)
end, { desc = "zk creates a note using selection as content" })
map("n", "<leader>zn", function()
  local title = vim.fn.input "Title: "
  local command = "ZkNew {dir = 'notes', edit = true, title = '" .. title .. "'}"
  vim.cmd(command)
end, { desc = "zk creates a note" })
map(
  "v",
  "<leader>zm",
  [[ :<C-U>'<,'>ZkMatch <cr> ]],
  { desc = "zk lists notes whose content matches visual selection" }
)
map("n", "<leader>zm", function()
  local match = vim.fn.input "Match terms: "
  local command = "ZkNotes {match={'" .. match .. "'} }"
  vim.cmd(command)
end, { desc = "zk lists all notes" })
map("n", "<leader>zt", [[ <cmd> ZkTags <cr> ]], { desc = "zk lists all tags" })
