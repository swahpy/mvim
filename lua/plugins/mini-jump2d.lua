local jump = require "mini.jump2d"
local map = vim.keymap.set
jump.setup {
  view = {
    dim = true,
  },
}

map("n", "sl", "<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.line_start)<CR>")
map("n", "sw", "<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.word_start)<CR>")
map("n", "ss", "<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<CR>")
map("n", "sp", function()
  jump.start {
    spotter = jump.gen_pattern_spotter "%p+",
    allowed_lines = { cursor_before = false, cursor_after = false },
    allowed_windows = { not_current = false },
    hl_group = "Search",
  }
end)
