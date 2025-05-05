local snippets = require "mini.snippets"
local gen_loader = snippets.gen_loader
local map = vim.keymap.set

snippets.setup {
  -- Array of snippets and loaders (see |snippets.config| for details).
  -- Nothing is defined by default. Add manually to have snippets to match.
  snippets = {
    -- Load custom file with global snippets first
    gen_loader.from_file "~/.config/nvim/snippets/global.json",

    -- Load snippets based on current language by reading files from
    -- "snippets/" subdirectories from 'runtimepath' directories.
    gen_loader.from_lang(),
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = { jump_next = "", jump_prev = "" },
}

-- integrate snippets in completion
snippets.start_lsp_server()

-- select from all available snippets in current context
local rhs = function()
  snippets.expand { match = false }
end
map("i", "<C-g><C-j>", rhs, { desc = "Expand all" })

-- Stop all sessions on Normal mode exit
local make_stop = function()
  local au_opts = { pattern = "*:n", once = true }
  au_opts.callback = function()
    while snippets.session.get() do
      snippets.session.stop()
    end
  end
  vim.api.nvim_create_autocmd("ModeChanged", au_opts)
end
local opts = { pattern = "MiniSnippetsSessionStart", callback = make_stop }
vim.api.nvim_create_autocmd("User", opts)

-- Stop session immediately after jumping to final tabstop ~
local fin_stop = function(args)
  if args.data.tabstop_to == "0" then
    snippets.session.stop()
  end
end
local au_opts = { pattern = "MiniSnippetsSessionJump", callback = fin_stop }
vim.api.nvim_create_autocmd("User", au_opts)
