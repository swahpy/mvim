local map = vim.keymap.set
local load = function(plugin, setup)
  return function()
    if setup then
      require(plugin).setup()
    else
      require(plugin)
    end
  end
end

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath "data" .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd 'echo "Installing `mini.nvim`" | redraw'
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd "packadd mini.nvim | helptags ALL"
  vim.cmd 'echo "Installed `mini.nvim`" | redraw'
end

-- Set up 'mini.deps' (customize to your liking)
local mini_deps = require "mini.deps"
mini_deps.setup { path = { package = path_package } }

-- Use 'mini.deps'. optional
-- `now()` and `later()` are helpers for a safe two-stage startup.
local add, now, later = mini_deps.add, mini_deps.now, mini_deps.later

-- Safely execute immediately
-- now(function()
--   add({
--     source = "comfysage/evergarden",
--   })
--   require 'evergarden'.setup()
--   vim.o.termguicolors = true
--   vim.cmd "colorscheme evergarden"
-- end)
now(function()
  vim.o.termguicolors = true
  vim.cmd "colorscheme randomhue"
end)
-- now(load "plugins.mini-starter")

-- safely execute later
later(load "plugins.mini-ai")
later(load("mini.align", true))
later(load "plugins.mini-animate")
later(load "plugins.mini-basics")
later(load("mini.bracketed", true))
later(load "plugins.mini-bufremove")
later(load "plugins.mini-clue")
later(load "mini.comment")
later(load "mini.cursorword")
later(load "plugins.mini-completion")
later(load "plugins.mini-files")
later(load "plugins.mini-hipatterns")
later(load("mini.icons", true))
-- add icon to completion items
later(require("mini.icons").tweak_lsp_kind)
later(load "plugins.mini-indentscope")
later(load("mini.jump", true))
later(load "plugins.mini-jump2d")
later(load "plugins.mini-map")
later(load "plugins.mini-misc")
later(load("mini.move", true))
later(load "plugins.mini-notify")
later(load("mini.operators", true))
later(load "plugins.mini-pairs")
-- disable mini.pairs for markdown files
-- so that no extra ]s being inserted in links
local f = function(args)
  vim.b[args.buf].minipairs_disable = true
end
vim.api.nvim_create_autocmd("Filetype", { pattern = "markdown", callback = f })
later(load "plugins.mini-pick")
later(load "plugins.mini-sessions")
later(load "plugins.mini-snippets")
later(load("mini.statusline", true))
later(load("mini.tabline", true))
later(load "plugins.mini-others")

--> non-mini plugins <--
-- arrow
later(function()
  add {
    source = "otavioschwanck/arrow.nvim",
  }
  require("arrow").setup {
    show_icons = true,
    leader_key = "-", -- Recommended to be a single key
    buffer_leader_key = "m", -- Per Buffer Mappings
  }
end)
-- lspsaga
later(function()
  add {
    source = "nvimdev/lspsaga.nvim",
    depends = {
      "nvim-treesitter/nvim-treesitter",
    },
  }
  require "plugins.lspsaga"
end)
-- conform
later(function()
  add {
    source = "stevearc/conform.nvim",
  }
  require "plugins.conform"
end)
-- treesitter
later(function()
  add {
    source = "nvim-treesitter/nvim-treesitter",
    hooks = {
      post_checkout = function()
        vim.cmd "TSUpdate"
      end,
    },
  }
  require "plugins.treesitter"
end)
-- better escape
later(function()
  add {
    source = "max397574/better-escape.nvim",
  }
  require("better_escape").setup()
end)
-- friendly-snippets
later(function()
  add {
    source = "rafamadriz/friendly-snippets",
  }
end)
-- undotree
later(function()
  add {
    source = "mbbill/undotree",
  }
  vim.g.undotree_ShortIndicators = 1
  vim.g.undotree_DiffAutoOpen = 0
  vim.g.undotree_SetFocusWhenToggle = 1
  map("n", "<leader>ut", "<cmd>UndotreeToggle<cr>", { desc = "Toggle undo tree" })
end)
-- zk-nvim
later(function()
  add {
    source = "zk-org/zk-nvim",
  }
end)
-- blink.cmp
-- later(function()
--   add {
--     source = "saghen/blink.cmp",
--     depends = { "rafamadriz/friendly-snippets" },
--     checkout = "v0.10.0",
--   }
--   require "plugins.blink-cmp"
-- end)
-- lspconfig
later(function()
  add {
    source = "neovim/nvim-lspconfig",
    depends = { "williamboman/mason.nvim" },
  }
  require "plugins.nvim-lspconfig"
  require("mason").setup()
end)
later(function()
  add {
    source = "akinsho/toggleterm.nvim",
  }
  require "plugins.toggle-term"
end)
-- render markdown
later(function()
  add {
    source = "MeanderingProgrammer/render-markdown.nvim",
    depends = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
  }
  require "plugins.rendermarkdown"
end)
-- markview
-- later(function()
--   add {
--     source = "OXY2DEV/markview.nvim",
--     depends = {
--       "nvim-treesitter/nvim-treesitter",
--     },
--   }
--   require "plugins.markview"
-- end)
-- swenv
later(function()
  add {
    source = "AckslD/swenv.nvim",
    depends = { "nvim-lua/plenary.nvim" },
  }
  require("swenv").setup {
    venvs_path = vim.fn.expand "~/.pyenv/versions/3.13.1/envs",
  }
  map("n", "<leader>pv", function()
    require("swenv.api").pick_venv()
  end, { desc = "pick a python virtual env" })
  map("n", "<leader>cv", function()
    local venv = require("swenv.api").get_current_venv()
    if venv ~= nil then
      print(venv.name)
    else
      print "no virtual env selected so far!"
    end
  end, { desc = "print current python virtual env" })
end)

later(function()
  require "options"
  require "mappings"
  -- To get more consistent behavior of `<CR>`, you can use this template in
  -- your 'init.lua' to make customized mapping: >lua
  local keycode = vim.keycode or function(x)
    return vim.api.nvim_replace_termcodes(x, true, true, true)
  end
  local keys = {
    ["cr"] = keycode "<CR>",
    ["ctrl-y"] = keycode "<C-y>",
    ["ctrl-y_cr"] = keycode "<C-y><CR>",
  }
  _G.cr_action = function()
    if vim.fn.pumvisible() ~= 0 then
      -- If popup is visible, confirm selected item or add new line otherwise
      local item_selected = vim.fn.complete_info()["selected"] ~= -1
      return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
    else
      return require("mini.pairs").cr()
    end
  end
  map("i", "<CR>", "v:lua._G.cr_action()", { expr = true })
end)
