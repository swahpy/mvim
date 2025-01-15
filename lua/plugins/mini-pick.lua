local pick = require "mini.pick"
local extra = require "mini.extra"
local map = vim.keymap.set

extra.setup {}
pick.setup {
  -- Keys for performing actions. See `:h MiniPick-actions`.
  mappings = {
    caret_left = "<A-h>",
    caret_right = "<A-l>",

    choose_in_split = "<A-s>",
    choose_in_vsplit = "<A-v>",

    delete_word = "<A-Bs>",

    mark = "<A-m>",
    mark_all = "<A-a>",

    move_down = "<A-j>",
    move_up = "<A-k>",

    paste = "<A-p>",

    refine = "<A-r>",
    refine_marked = "<C-r>",

    stop = "<A-q>",
  },

  -- General options
  options = {
    use_cache = true,
  },
}

map("n", "<leader>pf", function()
  pick.builtin.files()
end, { desc = "pick from files" })

map("n", "<leader>pp", function()
  pick.builtin.grep()
end, { desc = "pick from pattern matches" })

map("n", "<leader>pg", function()
  pick.builtin.grep_live()
end, { desc = "pick from pattern matches with live feedback" })

map("n", "<leader>ph", function()
  pick.builtin.help()
end, { desc = "pick from help tags" })

map("n", "<leader>pb", function()
  pick.builtin.buffers()
end, { desc = "pick from buffers" })

map("n", "<leader>pr", function()
  pick.builtin.resume()
end, { desc = "pick from latest pickers" })

map("n", "<leader>bl", function()
  extra.pickers.buf_lines()
end, { desc = "pick from buffer lines" })

map("n", "<leader>pc", function()
  extra.pickers.commands()
end, { desc = "pick from neovim commands" })

map("n", "<leader>pd", function()
  extra.pickers.diagnostic()
end, { desc = "pick from diagnostics" })

map("n", "<leader>po", function()
  extra.pickers.oldfiles()
end, { desc = "pick from old files" })

map("n", "<leader>gc", function()
  extra.pickers.git_commits()
end, { desc = "pick from git commits" })

map("n", "<leader>gh", function()
  extra.pickers.git_hunks()
end, { desc = "pick from git hunks" })

map("n", "<leader>plr", function()
  extra.pickers.lsp { scope = "references" }
end, { desc = "pick from lsp references" })

map("n", "<leader>plt", function()
  extra.pickers.lsp { scope = "type_definition" }
end, { desc = "pick from lsp type_definition" })

map("n", "<leader>pls", function()
  extra.pickers.lsp { scope = "workspace_symbol" }
end, { desc = "pick from lsp workspace_symbol" })

map("n", "<leader>pld", function()
  extra.pickers.lsp { scope = "definition" }
end, { desc = "pick from lsp definition" })

map("n", "<leader>pli", function()
  extra.pickers.lsp { scope = "implementation" }
end, { desc = "pick from lsp implementation" })

map("n", "<leader>plD", function()
  extra.pickers.lsp { scope = "declaration" }
end, { desc = "pick from lsp declaration" })

map("n", "<leader>plc", function()
  extra.pickers.lsp { scope = "document_symbol" }
end, { desc = "pick from lsp document_symbol" })
