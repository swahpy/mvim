local notify = require "mini.notify"
local map = vim.keymap.set

notify.setup()
local opts = { ERROR = { duration = 10000 } }
vim.notify = notify.make_notify(opts)

map("n", "<leader>nh", function()
  notify.show_history()
end, { desc = "show notification history" })

map("n", "<leader>cn", function()
  notify.clear()
end, { desc = "remove all active notifications" })
