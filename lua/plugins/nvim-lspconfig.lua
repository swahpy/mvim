local lspconfig = require "lspconfig"
-- local lsputil = require "lspconfig.util"
local map = vim.keymap.set

map("n", "<leader>ti", function()
  if vim.lsp.inlay_hint.is_enabled() then
    vim.lsp.inlay_hint.enable(false)
  else
    vim.lsp.inlay_hint.enable(true)
  end
end, { desc = "toggle lsp inlay hints" })

-- typical capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

-- on_init function
local on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

-- on_attach function
local on_attach = function(client, bufnr)
  -- Set up 'mini.completion' LSP part of completion
  vim.bo[bufnr].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"

  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  map("n", "gR", vim.lsp.buf.references, opts "Show references")

  -- defer textDocument/hover to basedpyright
  if client ~= nil and client.name == "ruff" then
    client.server_capabilities.hoverProvider = false
  end
end

-- lua_ls
lspconfig.lua_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      telemetry = {
        enable = false,
      },
    },
  },
  on_init = function(client)
    local join = vim.fs.joinpath
    local path = client.workspace_folders[1].name

    -- Don't do anything if there is project local config
    if vim.uv.fs_stat(join(path, ".luarc.json")) or vim.uv.fs_stat(join(path, ".luarc.jsonc")) then
      return
    end

    -- Apply neovim specific settings
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, join("lua", "?.lua"))
    table.insert(runtime_path, join("lua", "?", "init.lua"))

    local nvim_settings = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        version = "LuaJIT",
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          -- Make the server aware of Neovim runtime files
          vim.env.VIMRUNTIME,
          vim.fn.stdpath "config",
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
          "${3rd}/luv/library",
        },
      },
    }

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, nvim_settings)

    if client.supports_method "textDocument/semanticTokens" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
}

-- biome
lspconfig.biome.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  on_init = on_init,
}

-- ruff
lspconfig.ruff.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  on_init = on_init,
  trace = "messages",
  init_options = {
    settings = {
      logLevel = "debug",
    },
  },
}

-- basedpyright
lspconfig.basedpyright.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  on_init = on_init,
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticsMode = "openFilesOnly", -- workspace, openFilesOnly
        typeCheckingMode = "standard", -- off, basic, standard, strict, all
        ignore = { "*" },
        diagnosticSeverityOverrides = {
          reportUnusedImport = false, -- ruff handles this with F401
          reportAttributeAccessIssue = false,
        },
      },
    },
  },
}

-- marksman
-- lspconfig.marksman.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
-- }

-- zk
require("zk").setup {
  picker = "minipick",
  lsp = {
    -- `config` is passed to `vim.lsp.start_client(config)`
    config = {
      cmd = { "zk", "lsp" },
      name = "zk",
      capabilities = capabilities,
      on_attach = on_attach,
    },

    on_init = on_init,
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
map(
  "v",
  "<leader>zc",
  [[<cmd> ZkNewFromTitleSelection {dir = "notes", edit = true} <cr>]],
  { desc = "zk creates a note using selection as title" }
)
map("v", "<leader>zC", function()
  local title = vim.fn.input "Title: "
  local cmd = "'<,'>ZkNewFromContentSelection {dir = 'notes', edit = true, title = '" .. title .. "' }"
  vim.cmd(cmd)
end, { desc = "zk creates a note using selection as title" })
map("n", "<leader>zc", function()
  local title = vim.fn.input "Title: "
  local command = "ZkNew {dir = 'notes', edit = true, title = '" .. title .. "'}"
  vim.cmd(command)
end, { desc = "zk creates a note using selection as content" })
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

-- typos_lsp
lspconfig.typos_lsp.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  on_init = on_init,
}

-- emmet-language-server
lspconfig.emmet_language_server.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  on_init = on_init,
}
