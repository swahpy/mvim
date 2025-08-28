vim.pack.add({
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/rafamadriz/friendly-snippets",
})

local map = vim.keymap.set

local extra = require("mini.extra")
extra.setup({})

--> mini.ai
local ai = require("mini.ai")
local spec = ai.gen_spec
local gen_ai_spec = extra.gen_ai_spec
ai.setup({
  -- Number of lines within which textobject is searched
  n_lines = 500,
  custom_textobjects = {
    -- Tweak function call to not detect dot in function name
    f = spec.function_call({ name_pattern = "[%w_]" }),
    -- Function definition (needs treesitter queries with these captures)
    -- Make `|` select both edges in non-balanced way
    ["|"] = spec.pair("|", "|", { type = "non-balanced" }),
    -- tag
    t = {
      "<([%p%w]-)%f[^<%w][^<>]->.-</%1>",
      "^<.->().*()</[^/]->$",
    },
    -- snake_case, camelCase, PascalCase, etc; all capitalizations
    w = {
      {
        -- reference, https://github.com/echasnovski/mini.nvim/discussions/1434
        "%u[%l%d]+%f[^%l%d]",
        "%f[^%s%p][%l%d]+%f[^%l%d]",
        "^[%l%d]+%f[^%l%d]",
        "%f[^%s%p][%a%d]+%f[^%a%d]",
        "^[%a%d]+%f[^%a%d]",
      },
      "^().*()$",
    },
    u = spec.function_call(), -- u for "Usage"
    [" "] = { "%f[%S][%w%p]+%f[%s]", "^().*()$" }, -- match content between space
    -- from mini.extra
    g = gen_ai_spec.buffer(),
    D = gen_ai_spec.diagnostic(),
    I = gen_ai_spec.indent(),
    d = gen_ai_spec.number(),
    j = { "%f[^%c][^%c]*", "^%s*().-()%s*$" }, -- match whole line
  },
})

--> mini.basics
-- in order for leader key to work, mini.basic
-- shoule put before all keymaps using leader key.
require("mini.basics").setup({
  options = {
    extra_ui = true,
    win_borders = "double",
  },
  mappings = {
    windows = true,
    move_with_alt = true,
  },
  autocommands = {
    relnum_in_visual_mode = true,
  },
})

--> mini one-liners
require("mini.align").setup({})
local animate = require("mini.animate")
animate.setup({
  cursor = {
    enable = true,
    -- Neovide-like cursor movement with cubic easing
    timing = animate.gen_timing.cubic({
      duration = 150,
      unit = "total",
      easing = "out",
    }),
    path = animate.gen_path.line({
      predicate = function()
        return true
      end,
    }),
  },

  scroll = {
    enable = true,
    -- Optimized timing based on documentation recommendations
    -- Prevents conflicts with rapid scrolling while maintaining smoothness
    timing = function(_, n)
      return math.min(300 / n, 6)
    end,
    subscroll = animate.gen_subscroll.equal({
      max_output_steps = 80, -- Balanced for smoothness without performance issues
      predicate = function(total_scroll)
        return total_scroll > 0 -- Always animate any scroll
      end,
    }),
  },

})
require("mini.bracketed").setup({})
local bufremove = require("mini.bufremove")
bufremove.setup({})
map("n", "<leader>,", function()
  bufremove.unshow_in_window()
end, { desc = "switch between recent two buffers" })
map("n", "<leader>bd", function()
  bufremove.delete()
end, { desc = "delete current buffer" })
require("mini.cursorword").setup({})
require("mini.diff").setup({ view = { style = "sign" } })
map("n", "<leader>to", "<cmd>lua MiniDiff.toggle_overlay()<cr>", { desc = "toggle mini.diff overlay" })
local git = require("mini.git")
git.setup({})
map(
  "n",
  "<leader>gs",
  "<cmd>lua MiniGit.show_at_cursor()<cr>",
  { desc = "shows Git related data depending on context" }
)
local hipatterns = require("mini.hipatterns")
hipatterns.setup({ highlighters = { hex_color = hipatterns.gen_highlighter.hex_color() } })
local misc = require("mini.misc")
misc.setup({})
misc.setup_auto_root()
misc.setup_restore_cursor()
misc.setup_termbg_sync()
map("n", "<leader>z", "<cmd>lua MiniMisc.zoom()<cr>", { desc = "zoom in/out buffer" })
require("mini.move").setup({})
local notify = require("mini.notify")
notify.setup({})
vim.notify = notify.make_notify()
map("n", "<leader>nh", "<cmd>lua MiniNotify.show_history()<cr>", { desc = "show notification history" })
require("mini.icons").setup()
require("mini.icons").tweak_lsp_kind()
require("mini.operators").setup()
require("mini.pairs").setup({ modes = { command = true, terminal = true } })
require("mini.splitjoin").setup()
require("mini.statusline").setup()
require("mini.surround").setup({ n_lines = 500, respect_selection_type = true, search_method = "cover_or_next" })
require("mini.tabline").setup()
require("mini.visits").setup()
map("n", "<leader>l", "<cmd>lua MiniVisits.add_label()<cr>", { desc = "Add label" })
map("n", "<leader>L", "<cmd>lua MiniVisits.remove_label()<cr>", { desc = "Remove label" })

--> mini.completion
local completion = require("mini.completion")
-- local kind_priority = { Text = -1, Snippet = 99 }
local opts = {
  filtersort = "fuzzy",
  -- kind_priority = kind_priority
}
local process_items = function(items, base)
  return completion.default_process_items(items, base, opts)
end
completion.setup({
  window = {
    info = { border = "double" },
    signature = { border = "double" },
  },
  lsp_completion = {
    source_func = "omnifunc",
    auto_setup = false,
    lsp_completion = { process_items = process_items },
  },
  mappings = {
    force_twostep = "<C-t>",
    force_fallback = "<A-f>",
  },
})

--> mini.indentscope
local indent = require("mini.indentscope")
indent.setup({
  options = {
    indent_at_cursor = false,
  },
})
local f = function(args)
  vim.b[args.buf].miniindentscope_disable = true
end
vim.api.nvim_create_autocmd(
  "FileType",
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

--> mini.keymap
local keymap = require("mini.keymap")
local map_multistep = keymap.map_multistep
local tab_steps = { "pmenu_accept", "increase_indent", "jump_after_close" }
map_multistep({ "i", "s" }, "<Tab>", tab_steps)
local shifttab_steps = { "jump_before_open", "decrease_indent" }
map_multistep({ "i", "s" }, "<S-Tab>", shifttab_steps)
map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
map_multistep("i", "<BS>", { "hungry_bs", "minipairs_bs" })
local mode = { "i", "c", "x", "s" }
require("mini.keymap").map_combo(mode, "jk", "<BS><BS><Esc>")
require("mini.keymap").map_combo(mode, "kj", "<BS><BS><Esc>")
require("mini.keymap").map_combo("t", "jk", "<BS><BS><C-\\><C-n>")
require("mini.keymap").map_combo("t", "kj", "<BS><BS><C-\\><C-n>")
local map_combo = keymap.map_combo
map_combo({ "n", "x" }, "ll", "g$")
map_combo({ "n", "x" }, "hh", "g^")

--> mini.pick
local pick = require("mini.pick")
local win_config = function()
  local height = math.floor(0.618 * vim.o.lines)
  local width = math.floor(0.618 * vim.o.columns)
  return {
    anchor = "NW",
    height = height,
    width = width,
    row = math.floor(0.5 * (vim.o.lines - height)),
    col = math.floor(0.5 * (vim.o.columns - width)),
  }
end
pick.setup({
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
  },
  -- General options
  options = {
    use_cache = true,
  },
  window = { config = win_config },
})
-- files
map("n", "<leader>ff", function()
  pick.builtin.files()
end, { desc = "pick from files" })
map("n", "<leader>fo", function()
  extra.pickers.oldfiles()
end, { desc = "pick from old files" })
map("n", "<leader>fp", function()
  pick.builtin.grep()
end, { desc = "pick from pattern matches" })
map("n", "<leader>fg", function()
  pick.builtin.grep_live()
end, { desc = "pick from pattern matches with live feedback" })
-- neovim builtin
map("n", "<leader>fh", function()
  pick.builtin.help()
end, { desc = "pick from help tags" })
map("n", "<leader>fc", function()
  extra.pickers.commands()
end, { desc = "pick from neovim commands" })
map("n", "<leader>fd", function()
  extra.pickers.diagnostic()
end, { desc = "pick from diagnostics" })
-- buffer
map("n", "<leader>fb", function()
  pick.builtin.buffers()
end, { desc = "pick from buffers" })
map("n", "<leader>fl", function()
  extra.pickers.buf_lines({ scope = "current" })
end, { desc = "pick from buffer lines" })
map("n", "<leader>fk", function()
  extra.pickers.keymaps()
end, { desc = "pick from keymaps" })
map("n", "<leader>fT", function()
  extra.pickers.colorschemes()
end, { desc = "pick from colorschemes" })
map("n", "<leader>fr", function()
  pick.builtin.resume()
end, { desc = "pick from latest pickers" })
-- git
map("n", "<leader>fC", function()
  extra.pickers.git_commits()
end, { desc = "pick from git commits" })
map("n", "<leader>fH", function()
  extra.pickers.git_hunks()
end, { desc = "pick from git hunks" })
-- lsp
map("n", "<leader>fR", function()
  extra.pickers.lsp({ scope = "references" })
end, { desc = "pick from lsp references" })
map("n", "<leader>ft", function()
  extra.pickers.lsp({ scope = "type_definition" })
end, { desc = "pick from lsp type_definition" })
map("n", "<leader>fw", function()
  extra.pickers.lsp({ scope = "workspace_symbol" })
end, { desc = "pick from lsp workspace_symbol" })
map("n", "<leader>fd", function()
  extra.pickers.lsp({ scope = "definition" })
end, { desc = "pick from lsp definition" })
map("n", "<leader>fi", function()
  extra.pickers.lsp({ scope = "implementation" })
end, { desc = "pick from lsp implementation" })
map("n", "<leader>fD", function()
  extra.pickers.lsp({ scope = "declaration" })
end, { desc = "pick from lsp declaration" })
map("n", "<leader>fs", function()
  extra.pickers.lsp({ scope = "document_symbol" })
end, { desc = "pick from lsp document_symbol" })
-- visits
map("n", "<leader>vr", function()
  extra.pickers.visit_paths({ recency_weight = 1 })
end, { desc = "pick from recent cwd visit_paths" })
map("n", "<leader>vR", function()
  extra.pickers.visit_paths({ recency_weight = 1, cwd = "" })
end, { desc = "pick from recent global visit_paths" })
map("n", "<leader>vf", function()
  extra.pickers.visit_paths({ recency_weight = 0 })
end, { desc = "pick from frequent cwd visit_paths" })
map("n", "<leader>vF", function()
  extra.pickers.visit_paths({ recency_weight = 0, cwd = "" })
end, { desc = "pick from frequent global visit_paths" })
map("n", "<leader>vc", function()
  extra.pickers.visit_paths({ recency_weight = 0.5 })
end, { desc = "pick from frecent cwd visit_paths" })
map("n", "<leader>vC", function()
  extra.pickers.visit_paths({ recency_weight = 0.5, cwd = "" })
end, { desc = "pick from frecent global visit_paths" })
map("n", "<leader>vl", function()
  extra.pickers.visit_labels({})
end, { desc = "pick from cwd labels" })
map("n", "<leader>vL", function()
  extra.pickers.visit_labels({ cwd = "" })
end, { desc = "pick from global labels" })

--> mini.sessions
local sessions = require("mini.sessions")
sessions.setup({
  autoread = true,
  verbose = { read = true },
})
map("n", "<leader>ss", function()
  sessions.select()
end, { desc = "select session" })

--> mini.snippets
local snippets = require("mini.snippets")
local gen_loader = snippets.gen_loader
snippets.setup({
  snippets = {
    gen_loader.from_file("~/.config/nvim/snippets/global.json"),
    gen_loader.from_lang(),
  },
})
snippets.start_lsp_server()
local rhs = function()
  snippets.expand({ match = false })
end
map("i", "<C-g><C-j>", rhs, { desc = "Expand all" })
local make_stop = function()
  local au_opts = { pattern = "*:n", once = true }
  au_opts.callback = function()
    while snippets.session.get() do
      snippets.session.stop()
    end
  end
  vim.api.nvim_create_autocmd("ModeChanged", au_opts)
end
opts = { pattern = "MiniSnippetsSessionStart", callback = make_stop }
vim.api.nvim_create_autocmd("User", opts)

--> mini.trailspace
local trailspace = require("mini.trailspace")
trailspace.setup()
local cmd = "<cmd>lua MiniTrailspace.trim()<cr>"
map("n", "<leader>ts", cmd, { desc = "Trim all trailing whitespaces" })
cmd = "<Cmd>lua MiniTrailspace.trim_last_lines()<CR>"
map("n", "<leader>tl", cmd, { desc = "Trim all trailing empty lines" })
