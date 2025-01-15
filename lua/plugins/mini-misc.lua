local misc = require "mini.misc"
local map = vim.keymap.set

misc.setup {
  make_global = { "put", "put_text" },
}

misc.setup_restore_cursor()

map("n", "<leader>zz", function()
  misc.zoom()
end, { desc = "zoom in/out buffer" })
