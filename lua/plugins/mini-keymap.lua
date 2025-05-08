local keymap = require "mini.keymap"
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

local notify_many_keys = function(key)
  local lhs = string.rep(key, 5)
  local action = function()
    vim.notify("Too many " .. key)
  end
  keymap.map_combo({ "n", "x" }, lhs, action)
end
notify_many_keys "h"
notify_many_keys "j"
notify_many_keys "k"
notify_many_keys "l"
