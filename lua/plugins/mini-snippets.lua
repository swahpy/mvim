local snippets = require "mini.snippets"
local gen_loader = snippets.gen_loader
local map = vim.keymap.set

local match_strict = function(snips)
  -- Do not match with whitespace to cursor's left
  return snippets.default_match(snips, { pattern_fuzzy = "%S+" })
end

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
  expand = {
    match = match_strict,
  },
}

require("mini.deps").add {
  source = "kawre/neotab.nvim",
}
require("neotab").setup()

local loop_or_expand_or_jump = function()
  local can_expand = #snippets.expand { insert = false } > 0
  local is_active = snippets.session.get() ~= nil

  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  elseif can_expand then
    vim.schedule(snippets.expand)
    return ""
  elseif is_active then
    snippets.session.jump "next"
    return ""
  else
    return "<Plug>(neotab-out)"
  end
end
map("i", "<Tab>", loop_or_expand_or_jump, { expr = true })
local loop_or_jump_prev = function()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  else
    snippets.session.jump "prev"
  end
end
map("i", "<S-Tab>", loop_or_jump_prev, { expr = true })

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
