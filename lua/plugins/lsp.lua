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
  if client ~= nil and client:supports_method "textDocument/completion" then
    vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
  end
end
vim.api.nvim_create_autocmd("LspAttach", { callback = on_attach })

vim.lsp.config("*", {
  root_markers = { ".git" },
})

vim.lsp.set_log_level "WARN"

vim.lsp.enable { "luals", "basedpyright", "ruff" }
