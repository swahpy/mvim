local map = vim.keymap.set
local snacks = require "snacks"

snacks.setup {}

map("n", "<leader>co", function()
  snacks.bufdelete.other()
end, { desc = "close all buffers except current one" })

map("n", "<leader>gb", function()
  snacks.gitbrowse.open()
end, { desc = "open the repo of the active file in browser" })
