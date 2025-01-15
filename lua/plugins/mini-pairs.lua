local pairs = require "mini.pairs"
pairs.setup {
  modes = { command = true },
  mappings = {
    ["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },
    [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
  },
}
-- disable mini.pairs for markdown files
-- so that no extra ]s being inserted in links
local f = function(args)
  vim.b[args.buf].minipairs_disable = true
  -- pairs.unmap_buf(0, "i", "", "[]")
end
vim.api.nvim_create_autocmd("Filetype", { pattern = "markdown", callback = f })
