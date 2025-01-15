local minimap = require "mini.map"
local map = vim.keymap.set

minimap.setup {
  integrations = {
    minimap.gen_integration.builtin_search(),
    minimap.gen_integration.diff(),
    minimap.gen_integration.diagnostic(),
  },
  window = {
    width = 20,
    winblend = 75,
  },
  symbols = {
    encode = minimap.gen_encode_symbols.dot "4x2",
    scroll_view = "⣿",
  },
}

map("n", "<Leader>mc", minimap.close, { desc = "close mini map" })
map("n", "<Leader>mf", minimap.toggle_focus, { desc = "focus on mini map" })
map("n", "<Leader>mo", minimap.open, { desc = "open mini map" })
map("n", "<Leader>mr", minimap.refresh, { desc = "refresh mini map" })
map("n", "<Leader>ms", minimap.toggle_side, { desc = "mini map toggle side" })
map("n", "<Leader>mt", minimap.toggle, { desc = "toggle mini map" })
