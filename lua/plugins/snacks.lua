vim.pack.add({
  "https://github.com/folke/snacks.nvim",
})

local snacks = require("snacks")

snacks.setup({
  bigfile = { enabled = true },
  git = { enable = true },
  gitbrowse = { enable = true },
  image = { enable = true },
  input = { enable = true },
  notifier = { enable = true },
  quickfile = { enable = true },
  rename = { enable = true },
  scope = { enable = true },
  scratch = { enable = true },
  terminal = { enable = true },
  words = { enabled = true },
  zen = { enable = true },
})

snacks.dim()

local map = vim.keymap.set

map("n", "<leader>gb", function()
  snacks.git.blame_line()
end, { desc = "show git log for current line" })

map("n", "<leader>go", function()
  snacks.gitbrowse()
end, { desc = "open the repo of the active file in the browser (e.g., GitHub)" })

map("n", "<leader>si", function()
  snacks.image.hover()
end, { desc = "[Show] image" })

map("n", "<leader>;", function()
  snacks.input.input({}, function(values)
    vim.cmd(values)
  end)
end, { desc = "Open Snacks interactive input prompt" })

map("n", "<leader>rn", function()
  snacks.rename.rename_file()
end, { desc = "rename file" })

map("n", "<leader>.", function()
  snacks.scratch()
end, { desc = "toggle scratch buffer" })
map("n", "<leader>S", function()
  snacks.scratch.select()
end, { desc = "select scratch buffer" })

map({ "n", "i", "t" }, "<M-i>", function()
  snacks.terminal(nil, {
    win = {
      position = "float",
      border = "single",
    },
  })
end, { desc = "toggle snacks float terminal" })
map({ "n", "i", "t" }, "<M-->", function()
  snacks.terminal()
end, { desc = "toggle snacks terminal horizontally" })

map({ "n", "t" }, "]]", function()
  snacks.words.jump(vim.v.count1)
end, { desc = "next reference" })
map({ "n", "t" }, "[[", function()
  snacks.words.jump(-vim.v.count1)
end, { desc = "previous reference" })

map("n", "<leader>ze", function()
  snacks.zen()
end, { desc = "toggle zen mode" })
map("n", "<leader>zz", function()
  snacks.zen.zoom()
end, { desc = "toggle zoom" })

map("n", "<leader>bo", function()
  snacks.bufdelete.other()
end, { desc = "delete all buffers except the current one" })
map("n", "<leader>bx", function()
  snacks.bufdelete()
end, { desc = "delete current buffer" })

map("n", "<leader>sn", function()
  snacks.notifier.show_history()
end, { desc = "[Show] notify (snacks)" })
