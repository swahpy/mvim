local markview = require "markview"

markview.setup {
  filetypes = { "markdown" },
  --- Vim modes where the preview is shown
  ---@type string[]
  modes = { "n", "no", "i", "c" },
  hybrid_modes = { "i" },
  headings = {
    shift_width = 0,
    heading_1 = {
      align = "center",
      icon = "󰲠 ",
      hl = "",
      style = "label",
    },
    heading_2 = {
      icon = "󰲢 ",
      hl = "",
    },
    heading_3 = {
      icon = "󰲤 ",
      hl = "",
    },
    heading_4 = {
      icon = "󰲦 ",
      hl = "",
    },
    heading_5 = {
      icon = "󰲨 ",
      hl = "",
    },
    heading_6 = {
      icon = "󰲪 ",
      hl = "",
    },
  },
  inline_codes = {
    hl = "",
  },
}

require("markview.extras.editor").setup {
  --- The minimum & maximum window width
  --- If the value is smaller than 1 then
  --- it is used as a % value.
  ---@type [ number, number ]
  width = { 0.5, 0.75 },

  --- The minimum & maximum window height
  ---@type [ number, number ]
  height = { 0.3, 0.75 },

  --- Delay(in ms) for window resizing
  --- when typing.
  ---@type integer
  debounce = 50,

  --- Callback function to run on
  --- the floating window.
  --- @type fun(buf:integer, win:integer): nil
  --- @diagnostic disable-next-line
  callback = function(buf, win) end,
}

vim.keymap.set("n", "<leader>O", [[<cmd> MarkOpen <cr>]], { desc = "open link" })
