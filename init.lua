local load = function(plugin, opts)
  opts = opts or {}
  return function()
    local module = require(plugin)
    if type(module) == "table" and vim.is_callable(module.setup) then
      module.setup(opts)
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
now(function()
  add {
    source = "comfysage/evergarden",
  }
  require("evergarden").setup {}
  vim.o.termguicolors = true
  vim.cmd "colorscheme evergarden"
end)
-- now(function()
--   vim.o.termguicolors = true
--   vim.cmd "colorscheme randomhue"
-- end)
-- now(load "plugins.mini-starter")

-- safely execute later
later(load "plugins.mini-ai")
later(load "mini.align")
later(load "plugins.mini-animate")
later(load("mini.basics", {
  options = { extra_ui = true, win_borders = "single" },
  mappings = { basic = true, windows = true, move_with_alt = true },
}))
later(load "mini.bracketed")
later(load "mini.bufremove")
later(load "plugins.mini-clue")
later(load "mini.comment")
later(load "plugins.mini-completion")
later(load "mini.cursorword")
later(load("mini.diff", { view = { style = "sign" } }))
later(load "plugins.mini-files")
later(load "mini.git")
later(load "plugins.mini-hipatterns")
later(load "mini.icons")
later(load "plugins.mini-indentscope")
later(load "mini.jump")
later(load("mini.jump2d", { view = { dim = true } }))
later(load "plugins.mini-map")
later(load("mini.misc", { make_global = { "put", "put_text" } }))
require("mini.misc").setup_restore_cursor()
later(load "mini.move")
later(load "mini.notify")
vim.notify = require("mini.notify").make_notify { ERROR = { duration = 10000 } }
later(load "mini.operators")
later(load "plugins.mini-pairs")
later(load "plugins.mini-pick")
later(load "plugins.mini-sessions")
later(load "plugins.mini-snippets")
later(load("mini.splitjoin", { mappings = { toggle = "gS", split = "gs", join = "gj" } }))
later(load "mini.statusline")
later(load("mini.surround", { n_lines = 500, respect_selection_type = true, search_method = "cover_or_next" }))
later(load "mini.tabline")
later(load "mini.trailspace")
later(load "mini.visits")

--> non-mini plugins <--
-- arrow
later(function()
  add { source = "otavioschwanck/arrow.nvim" }
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
  add { source = "stevearc/conform.nvim" }
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
  add { source = "max397574/better-escape.nvim" }
  require("better_escape").setup()
end)
-- friendly-snippets
later(function()
  add { source = "rafamadriz/friendly-snippets" }
end)
-- undotree
later(function()
  add { source = "mbbill/undotree" }
  vim.g.undotree_ShortIndicators = 1
  vim.g.undotree_DiffAutoOpen = 0
  vim.g.undotree_SetFocusWhenToggle = 1
end)
-- zk-nvim
later(function()
  add { source = "zk-org/zk-nvim" }
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
-- toggleterm
later(function()
  add { source = "akinsho/toggleterm.nvim" }
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
later(function()
  add { source = "folke/snacks.nvim" }
  require "plugins.snack"
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
-- later(function()
--   add {
--     source = "AckslD/swenv.nvim",
--     depends = { "nvim-lua/plenary.nvim" },
--   }
--   require "plugins.swenv"
-- end)

later(function()
  require "options"
  require "mappings"
end)
