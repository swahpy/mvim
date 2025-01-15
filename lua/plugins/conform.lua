local conform = require "conform"
conform.setup {
  formatters_by_ft = {
    css = { "biome" },
    html = { "prettier" },
    javascript = { "biome" },
    json = { "biome" },
    lua = { "stylua" },
    markdown = { "prettier" },
    python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
  },
}
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.keymap.set("n", "<leader>fm", function()
  conform.format()
end, { desc = "conform format" })
