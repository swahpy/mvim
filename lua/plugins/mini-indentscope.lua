local indent = require "mini.indentscope"

indent.setup {
  options = {
    indent_at_cursor = false,
  },
}

local f = function(args)
  vim.b[args.buf].miniindentscope_disable = true
end
vim.api.nvim_create_autocmd(
  "Filetype",
  { pattern = { "mason", "checkhealth", "toggleterm", "markdown" }, callback = f }
)
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  desc = "Disable indentscope for certain buftypes",
  callback = function()
    local ignore_buftypes = {
      "help",
    }
    local bt = vim.bo.buftype
    if vim.tbl_contains(ignore_buftypes, bt) then
      vim.b.miniindentscope_disable = true
    end
  end,
})
