local bufremove = require "mini.bufremove"
local map = vim.keymap.set

bufremove.setup()
map("n", "<leader>nb", [[ <cmd> enew <cr> ]], { desc = "create a new buffer" })
map("n", "<leader>x", function()
  bufremove.delete()
end, { desc = "delete current buffer using :bdelete" })
map("n", "<leader>us", function()
  bufremove.unshow()
end, { desc = "stop showing current buffer in all windows" })
