vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  --{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
})

-- Ensure installed
--stylua: ignore
local ensure_installed = {
  "lua", "vim", "vimdoc", "query", "json",
  "yaml", "markdown", "printf", "toml",
  "markdown_inline", "bash", "go", "gomod",
  "gowork", "gosum", "python", "regex", "html",
}
local isnt_installed = function(lang)
  return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
end
local to_install = vim.tbl_filter(isnt_installed, ensure_installed)
if #to_install > 0 then
  require("nvim-treesitter").install(to_install)
end

-- Ensure enabled
local filetypes = vim.iter(ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable()
vim.list_extend(filetypes, { "markdown", "pandoc" })
local ts_start = function(ev)
  vim.treesitter.start(ev.buf)
end
vim.api.nvim_create_autocmd("FileType", { pattern = filetypes, callback = ts_start })
