vim.pack.add({
  "https://github.com/nvim-mini/mini.nvim",
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

--> mini.animate
local animate = require("mini.animate")
animate.setup({
  cursor = {
    enable = true,
    -- Neovide-like cursor movement with cubic easing
    timing = animate.gen_timing.quartic({
      duration = 2,
      unit = "step",
      easing = "in-out",
    }),
    path = animate.gen_path.line(),
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

--> mini.clue
local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },
    -- Built-in completion
    { mode = "i", keys = "<C-x>" },
    -- `g` key
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },
    -- Marks
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },
    -- Registers
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },
    -- Window commands
    { mode = "n", keys = "<C-w>" },
    -- `z` key
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
    -- `[` and `]` key
    { mode = "n", keys = "[" },
    { mode = "x", keys = "[" },
    { mode = "n", keys = "]" },
    { mode = "x", keys = "]" },
    -- \ key
    { mode = "n", keys = "\\" },
  },
  clues = {
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    { mode = "n", keys = "<Leader>f", desc = "+MiniPick" },
    { mode = "n", keys = "<Leader>j", desc = "+MiniJump2d" },
    { mode = "n", keys = "<Leader>v", desc = "+MiniVisits" },
    { mode = "n", keys = "]h", postkeys = "]" },
    { mode = "n", keys = "]b", postkeys = "]" },
    { mode = "n", keys = "[h", postkeys = "[" },
    { mode = "n", keys = "[b", postkeys = "[" },
    miniclue.gen_clues.windows({
      submode_move = true,
      submode_navigate = true,
      submode_resize = true,
    }),
  },
})

--> mini one-liners
require("mini.align").setup({})
require("mini.bracketed").setup({})
local bufremove = require("mini.bufremove")
bufremove.setup({})
map("n", "<leader>,", function()
  bufremove.unshow_in_window()
end, { desc = "switch between recent two buffers" })
map("n", "<leader>bd", function()
  bufremove.delete()
end, { desc = "delete current buffer" })
map("n", "<leader>bw", function()
  bufremove.wipeout()
end, { desc = "wipeout current buffer" })
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
require("mini.jump").setup({})
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
local kind_priority = { Text = -1, Snippet = 99 }
local opts = {
  filtersort = "fuzzy",
  kind_priority = kind_priority,
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

--> mini.files
local files = require("mini.files")
local cmd = vim.api.nvim_create_autocmd
files.setup({
  content = {
    -- filter hidden files on explorer opening.
    filter = function(fs_entry)
      return not vim.startswith(fs_entry.name, ".")
    end,
  },
  mappings = {
    synchronize = "w",
  },
  options = {
    permanent_delete = false,
  },
})
-- toggle files
map("n", "-", function()
  if not files.close() then
    files.open(vim.api.nvim_buf_get_name(0))
  end
end, { desc = "open mini files" })
-- open preview
map("n", "<C-p>", function()
  files.refresh({ windows = { preview = true, width_preview = 80 } })
end, { desc = "enable file content preview" })
-- toggle hidden files
local show_dotfiles = false
local filter_show = function(_)
  return true
end
local filter_hide = function(fs_entry)
  return not vim.startswith(fs_entry.name, ".")
end
local toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and filter_show or filter_hide
  files.refresh({ content = { filter = new_filter } })
end
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    map("n", "g.", toggle_dotfiles, { buffer = buf_id })
  end,
})
local map_split = function(buf_id, lhs, direction, close_on_file)
  local rhs = function()
    local new_target_window
    local cur_target_window = files.get_explorer_state().target_window
    if cur_target_window ~= nil then
      vim.api.nvim_win_call(cur_target_window, function()
        vim.cmd("belowright " .. direction .. " split")
        new_target_window = vim.api.nvim_get_current_win()
      end)
      files.set_target_window(new_target_window)
      files.go_in({ close_on_file = close_on_file })
    end
  end
  local desc = "Open in " .. direction .. " split"
  if close_on_file then
    desc = desc .. " and close"
  end
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end
cmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    map_split(buf_id, "_", "horizontal", false)
    map_split(buf_id, "|", "vertical", false)
  end,
})
-- set custom bookmarks
local set_mark = function(id, path, desc)
  files.set_bookmark(id, path, { desc = desc })
end
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesExplorerOpen",
  callback = function()
    set_mark("c", vim.fn.stdpath("config"), "Config") -- path
    set_mark("w", vim.fn.getcwd, "Working directory") -- callable
    set_mark("~", "~", "Home directory")
  end,
})
-- Set focused directory as current working directory
local set_cwd = function()
  local path = (files.get_fs_entry() or {}).path
  if path == nil then
    return vim.notify("Cursor is not on valid entry")
  end
  vim.fn.chdir(vim.fs.dirname(path))
end
-- Yank in register full path of entry under cursor
local yank_path = function()
  local path = (files.get_fs_entry() or {}).path
  if path == nil then
    return vim.notify("Cursor is not on valid entry")
  end
  vim.fn.setreg(vim.v.register, path)
end
-- Open path with system default handler (useful for non-text files)
local ui_open = function()
  vim.ui.open(files.get_fs_entry().path)
end
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local b = args.data.buf_id
    map("n", "g~", set_cwd, { buffer = b, desc = "Set cwd" })
    map("n", "gX", ui_open, { buffer = b, desc = "OS open" })
    map("n", "gy", yank_path, { buffer = b, desc = "Yank path" })
  end,
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

--> mini.jump2d
local jump2d = require("mini.jump2d")
jump2d.setup({
  view = {
    dim = true,
    n_steps_ahead = 2,
  },
})
map(
  { "o", "x", "n" },
  "<leader>jw",
  "<cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.word_start)<cr>",
  { desc = "jump to word" }
)
map(
  { "o", "x", "n" },
  "<leader>jl",
  "<cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.line_start)<cr>",
  { desc = "jump to line" }
)
map(
  { "o", "x", "n" },
  "<leader>jf",
  "<cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<cr>",
  { desc = "jump to single single_character" }
)
map({ "o", "x", "n" }, "<leader>jp", function()
  jump2d.start({
    spotter = jump2d.gen_spotter.pattern("%p+"),
    view = { n_steps_ahead = 0 },
  })
end, { desc = "jump to digits" })
map({ "o", "x", "n" }, "<leader>jd", function()
  jump2d.start({ spotter = jump2d.gen_spotter.pattern("%d+") })
end, { desc = "jump to digits" })
map(
  { "o", "x", "n" },
  "<Cr>",
  "<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<CR>",
  { desc = "jump to single_character" }
)

--> mini.keymap
local keymap = require("mini.keymap")
local map_multistep = keymap.map_multistep
local tab_steps = { "pmenu_next", "increase_indent", "jump_after_close" }
map_multistep({ "i", "s" }, "<Tab>", tab_steps)
local shifttab_steps = { "pmenu_prev", "jump_before_open", "decrease_indent" }
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
map("n", '<leader>f"', function()
  extra.pickers.registers()
end, { desc = "pick from registers" })
map("n", "<leader>fm", function()
  extra.pickers.marks()
end, { desc = "pick from marks" })
-- neovim builtin
map("n", "<leader>fh", function()
  pick.builtin.help()
end, { desc = "pick from help tags" })
map("n", "<leader>fc", function()
  extra.pickers.commands()
end, { desc = "pick from neovim commands" })
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
  extra.pickers.diagnostic()
end, { desc = "pick from diagnostics" })
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
cmd = "<cmd>lua MiniTrailspace.trim()<cr>"
map("n", "<leader>ts", cmd, { desc = "Trim all trailing whitespaces" })
cmd = "<Cmd>lua MiniTrailspace.trim_last_lines()<CR>"
map("n", "<leader>tl", cmd, { desc = "Trim all trailing empty lines" })
