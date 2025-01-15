local map = vim.keymap.set

local diff = require "mini.diff"
diff.setup {
  view = { style = "sign" },
}
map("n", "<leader>to", function()
  diff.toggle_overlay(0)
end, { desc = "toggle mini.diff overlay" })

require("mini.git").setup()
local rhs = "<Cmd>lua MiniGit.show_at_cursor()<CR>"
map({ "n", "x" }, "<Leader>gs", rhs, { desc = "Show at cursor" })

require("mini.splitjoin").setup {
  mappings = { toggle = "gS", split = "gs", join = "gj" },
}

require("mini.surround").setup {
  n_lines = 500,
  respect_selection_type = true,
  search_method = "cover_or_next",
}

local trim = require "mini.trailspace"
trim.setup()
map("n", "<leader>ts", function()
  trim.trim()
end, { desc = "Trim all trailing whitespaces" })
map("n", "<leader>tl", function()
  trim.trim_last_lines()
end, { desc = "Trim all trailing empty lines" })
