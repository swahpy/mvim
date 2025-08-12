vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local conform = require("conform")
conform.setup({
  formatters_by_ft = {
    css = { "biome" },
    go = { "goimports", "gofumpt" },
    html = { "djlint" },
    javascript = { "biome" },
    json = { "biome" },
    lua = { "stylua" },
    markdown = { "prettier" },
    python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
    toml = { "taplo" },
    yaml = { "yq" },
  },
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.keymap.set("n", "<M-f>", function()
  conform.format()
end, { desc = "conform format" })
