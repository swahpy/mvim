-- configuration for mini.keymap
local mini_keymap_setup = function(_, opts)
  local keymap = require("mini.keymap")
  local map_multistep = keymap.map_multistep
  local map_combo = keymap.map_combo

  -- Setup multi steps
  local tab_steps = {
    "pmenu_next",
    "increase_indent",
    "minisnippets_next",
    "jump_after_close",
    "jump_after_tsnode",
  }
  map_multistep("i", "<Tab>", tab_steps)
  local shifttab_steps = {
    "pmenu_prev",
    "decrease_indent",
    "minisnippets_prev",
    "jump_before_open",
    "jump_before_tsnode",
  }
  map_multistep("i", "<S-Tab>", shifttab_steps)
  map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
  map_multistep("i", "<BS>", { "minipairs_bs" })

  -- Support most common modes. This can also contain 't', but would
  -- only mean to press `<Esc>` inside terminal.
  local mode = { "i", "c", "x", "s" }
  map_combo(mode, "jk", "<BS><BS><Esc>")

  -- To not have to worry about the order of keys, also map "kj"
  map_combo(mode, "kj", "<BS><BS><Esc>")

  -- Escape into Normal mode from Terminal mode
  map_combo("t", "jk", "<BS><BS><C-\\><C-n>")
  map_combo("t", "kj", "<BS><BS><C-\\><C-n>")

  -- navigation
  map_combo({ "n", "x" }, "ll", "g$")
  map_combo({ "n", "x" }, "hh", "g^")
end

local mini_completion_setup = function(_, opts)
  local completion = require("mini.completion")
  local opts = { filtersort = "fuzzy" }
  local process_items = function(items, base)
    return completion.default_process_items(items, base, opts)
  end

  completion.setup({
    window = {
      info = { border = "double" },
      signature = { border = "double" },
    },
    lsp_completion = {
      source_func = "omnifunc",
      auto_setup = false,
      lsp_completion = { process_items = process_items },
    },
    mappings = {
      force_twostep = "<C-t>",
      force_fallback = "<A-f>",
    },
  })

  -- Use fuzzy matching for built-in completion
  if vim.fn.has("nvim-0.11") == 1 then
    vim.opt.completeopt:append("fuzzy")
  end

  -- add icon to completion items
  require("mini.icons").tweak_lsp_kind()
end

local mini_snippet_setup = function(_, opts)
  local snippets = require("mini.snippets")
  local gen_loader = snippets.gen_loader
  local map = vim.keymap.set

  snippets.setup({
    -- Array of snippets and loaders (see |snippets.config| for details).
    -- Nothing is defined by default. Add manually to have snippets to match.
    snippets = {
      -- Load custom file with global snippets first
      gen_loader.from_file("~/.config/nvim/snippets/global.json"),

      -- Load snippets based on current language by reading files from
      -- "snippets/" subdirectories from 'runtimepath' directories.
      gen_loader.from_lang(),
    },

    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = { jump_next = "", jump_prev = "" },
  })

  -- integrate snippets in completion
  snippets.start_lsp_server()

  -- select from all available snippets in current context
  local rhs = function()
    snippets.expand({ match = false })
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
end

local mini_setup = function(_, opts)
  mini_keymap_setup(_, opts)
  -- mini_completion_setup(_, opts)
  -- mini_snippet_setup(_, opts)
end

return {
  "echasnovski/mini.nvim",
  -- enabled = false,
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  version = false,
  event = "VeryLazy",
  config = mini_setup,
}
