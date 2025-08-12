vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

require("oil").setup({
  delete_to_trash = true, -- Delete files to trash instead of permanently
  keymaps = {
    ["h"] = { "actions.parent", mode = "n" },
    ["l"] = "actions.select",
    ["|"] = { "actions.select", opts = { vertical = true } },
    ["_"] = { "actions.select", opts = { horizontal = true } },
    ["gr"] = { "actions.open_cwd", mode = "n" },
    ["q"] = { "actions.close", mode = "n" },
  },
})

local map = vim.keymap.set
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
map("n", "<leader>-", "<cmd>Oil --float<cr>", { desc = "Open parent directory" })
