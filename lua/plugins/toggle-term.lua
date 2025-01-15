local term = require "toggleterm"
local map = vim.keymap.set

term.setup {
  size = function(t)
    if t.direction == "horizontal" then
      return vim.o.lines * 0.4
    elseif t.direction == "vertical" then
      return vim.o.columns * 0.5
    end
  end,
  shade_terminals = false,
  float_opts = {
    border = "single",
    -- like `size`, width, height, row, and col can be a number or function which is passed the current terminal
    width = function()
      return math.floor(vim.o.columns * 0.8)
    end,
    height = function()
      return math.floor(vim.o.lines * 0.6)
    end,
    winblend = 3,
    title_pos = "center", -- position of the title of the floating window
  },
}

map({ "n", "t", "i" }, "<A-i>", [[<cmd> ToggleTerm direction=float <cr>]], { desc = "toggleterm float" })
map(
  { "n", "t", "i" },
  "<A-->",
  [[<cmd> exe v:count1 . 'ToggleTerm direction=horizontal' <cr>]],
  { desc = "toggleterm horizontal" }
)
map(
  { "n", "t", "i" },
  "<A-v>",
  [[<cmd> exe v:count1 . 'ToggleTerm direction=vertical' <cr>]],
  { desc = "toggleterm vertical" }
)
map("v", "<leader>s", function()
  term.send_lines_to_terminal("visual_selection", true, { args = vim.v.count })
end, { desc = "send current visual selection to terminal" })

map("n", "<leader>ll", function()
  term.send_lines_to_terminal("single_line", true, { args = vim.v.count })
end, { desc = "+Send current line to terminal" })

-- create mappings in terminal
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd "autocmd! TermOpen term://*toggleterm* lua set_terminal_keymaps()"
