local pairs = require "mini.pairs"

pairs.setup {
  modes = { command = true },
}

-- Insert `<>` pair if `<` is typed at line start, don't register for `<CR>`
local lt_opts = {
  action = "open",
  pair = "<>",
  neigh_pattern = "[\r\"'].",
  register = { cr = false },
}
pairs.map("i", "<", lt_opts)

local gt_opts = { action = "close", pair = "<>", register = { cr = false } }
pairs.map("i", ">", gt_opts)
