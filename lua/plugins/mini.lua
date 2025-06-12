local map = vim.keymap.set

local mini_basic_setup = function(_, opts)
  require("mini.basics").setup()
  map("n", "gO", "v:lua.MiniBasics.put_empty_line(v:true)", { expr = true, desc = "Put empty line above" })
  map("n", "go", "v:lua.MiniBasics.put_empty_line(v:false)", { expr = true, desc = "Put empty line below" })
end

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

local mini_operators_setup = function(_, opts)
  local operators = require("mini.operators")
  operators.setup()
end

local mini_splitjoin_setup = function(_, opts)
  local splitjoin = require("mini.splitjoin")
  splitjoin.setup()
end

local mini_trailspace_setup = function(_, opts)
  local trailspace = require("mini.trailspace")
  trailspace.setup()
  local rhs = "<cmd>lua MiniTrailspace.trim()<cr>"
  map("n", "<leader>ts", rhs, { desc = "Trim all trailing whitespaces" })
  rhs = "<Cmd>lua MiniTrailspace.trim_last_lines()<CR>"
  map("n", "<leader>tl", rhs, { desc = "Trim all trailing empty lines" })
end

local mini_setup = function(_, opts)
  mini_basic_setup(_, opts)
  mini_keymap_setup(_, opts)
  mini_operators_setup(_, opts)
  mini_trailspace_setup(_, opts)
  mini_splitjoin_setup(_, opts)
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
