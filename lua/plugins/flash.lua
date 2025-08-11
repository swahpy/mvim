vim.pack.add({ "https://github.com/folke/flash.nvim" })

local map = vim.keymap.set

local flash = require("flash")
flash.setup({
	modes = {
		search = {
			enabled = true,
		},
	},
})
map({ "n", "x", "o" }, "S", function()
	require("flash").jump()
end, { desc = "Flash Treesitter" })
