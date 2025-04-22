-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
local map = vim.keymap.set

map("n", "<leader>ti", function()
  if vim.lsp.inlay_hint.is_enabled() then
    vim.lsp.inlay_hint.enable(false)
  else
    vim.lsp.inlay_hint.enable(true)
  end
end, { desc = "toggle lsp inlay hints" })

local on_attach = function(args)
  -- enable mini completion
  vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"

  local client = vim.lsp.get_client_by_id(args.data.client_id)

  local function opts(desc)
    return { buffer = args.buf, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map({ "n", "x" }, "gq", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts "Format code")
  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  map("n", "gR", vim.lsp.buf.references, opts "Show references")

  -- defer textDocument/hover to basedpyright
  if client ~= nil and client.name == "ruff" then
    client.server_capabilities.hoverProvider = false
  end

  -- enable nvim completion
  -- if client ~= nil and client:supports_method "textDocument/completion" then
  --   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
  -- end
end
vim.api.nvim_create_autocmd("LspAttach", { callback = on_attach })

local capabilities = vim.lsp.protocol.make_client_capabilities()
local completion = require "mini.completion"
capabilities = vim.tbl_deep_extend("force", capabilities, completion.get_lsp_capabilities())
vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.set_log_level "DEBUG"

vim.lsp.enable { "luals", "pyright", "ruff", "typoslsp" }

----------------
--> zk setup <--
----------------
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
    on_attach = on_attach,
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
