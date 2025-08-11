vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

local nts = require("nvim-treesitter")
nts.setup({
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "query",
    "json",
    "yaml",
    "markdown",
    "printf",
    "toml",
    "markdown_inline",
    "bash",
    "go",
    "gomod",
    "gowork",
    "gosum",
    "python",
    "regex",
    "html",
  },
  highlight = { enable = true },
})
local autocmd = vim.api.nvim_create_autocmd
autocmd("PackChanged", { -- update treesitter parsers/queries with plugin updates
	group = augroup,
	callback = function(args)
		local spec = args.data.spec
		if spec and spec.name == "nvim-treesitter" and args.data.kind == "update" then
			vim.schedule(function()
				nts.update()
			end)
		end
	end,
})
autocmd("FileType", { -- enable treesitter highlighting and indents
	group = augroup,
	callback = function(args)
		local filetype = args.match
		local lang = vim.treesitter.language.get_lang(filetype)
		if vim.treesitter.language.add(lang) then
			if vim.treesitter.query.get(filetype, "indents") then
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
			vim.treesitter.start()
		end
	end,
})
