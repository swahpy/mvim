vim.pack.add({
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/rafamadriz/friendly-snippets",
})

local map = vim.keymap.set

-- An example helper to create a Normal mode mapping
local nmap = function(lhs, rhs, desc)
  -- See `:h vim.keymap.set()`
  vim.keymap.set("n", lhs, rhs, { desc = desc })
end

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
    { mode = "n", keys = "<Leader>a", desc = "+AI | Sidekick" },
    { mode = "n", keys = "<Leader>b", desc = "+Buffers" },
    { mode = "n", keys = "<Leader>f", desc = "+Find" },
    { mode = "n", keys = "<Leader>g", desc = "+Git" },
    { mode = "n", keys = "<Leader>j", desc = "+MiniJump2d jump" },
    { mode = "n", keys = "<Leader>l", desc = "+Lsp" },
    { mode = "n", keys = "<Leader>o", desc = "+Obsidian" },
    { mode = "n", keys = "<Leader>q", desc = "+Quickfix" },
    { mode = "n", keys = "<Leader>r", desc = "+Rename" },
    { mode = "n", keys = "<Leader>s", desc = "+Select | Show | Session" },
    { mode = "n", keys = "<Leader>t", desc = "+Toggle | Trim" },
    { mode = "n", keys = "<Leader>v", desc = "+MiniVisits visit" },
    { mode = "n", keys = "<Leader>z", desc = "+Zen | Zoom" },
    miniclue.gen_clues.windows({
      submode_move = true,
      submode_navigate = true,
      submode_resize = true,
    }),
  },
})

--> mini one-liners
require("mini.align").setup()
require("mini.bracketed").setup()
local bufremove = require("mini.bufremove")
bufremove.setup()
nmap("<leader>,", function()
  bufremove.unshow_in_window()
end, "switch between recent two buffers")
nmap("<leader>bb", function()
  bufremove.unshow_in_window()
end, "switch between recent two buffers")
nmap("<leader>bd", function()
  bufremove.delete()
end, "delete current buffer")
nmap("<leader>bw", function()
  bufremove.wipeout()
end, "wipeout current buffer")
require("mini.cursorword").setup()
require("mini.diff").setup({ view = { style = "sign" } })
nmap("<leader>to", "<cmd>lua MiniDiff.toggle_overlay()<cr>", "toggle mini.diff overlay")
local git = require("mini.git")
git.setup()
nmap("<leader>gA", "<Cmd>Git diff --cached<CR>", "Added diff")
nmap("<leader>ga", "<Cmd>Git diff --cached -- %<CR>", "Added diff buffer")
nmap("<leader>gc", "<Cmd>Git commit<CR>", "Commit")
nmap("<leader>gC", "<Cmd>Git commit --amend<CR>", "Commit amend")
nmap("<leader>gD", "<Cmd>Git diff<CR>", "Diff")
nmap("<leader>gd", "<Cmd>Git diff -- %<CR>", "Diff buffer")
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_log_buf_cmd = git_log_cmd .. " --follow -- %"
nmap("<leader>gL", "<Cmd>" .. git_log_cmd .. "<CR>", "Log")
nmap("<leader>gl", "<Cmd>" .. git_log_buf_cmd .. "<CR>", "Log buffer")
nmap("<leader>go", "<Cmd>lua MiniDiff.toggle_overlay()<CR>", "Toggle overlay")
nmap("<leader>gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at cursor")

local hipatterns = require("mini.hipatterns")
hipatterns.setup({ highlighters = { hex_color = hipatterns.gen_highlighter.hex_color() } })
require("mini.jump").setup()
local misc = require("mini.misc")
misc.setup()
misc.setup_auto_root()
misc.setup_restore_cursor()
misc.setup_termbg_sync()
-- map("n", "<leader>z", "<cmd>lua MiniMisc.zoom()<cr>", { desc = "zoom in/out buffer" })
require("mini.move").setup()
require("mini.notify").setup()
nmap("<leader>sN", "<cmd>lua MiniNotify.show_history()<cr>", "[Show] notify (mini)")
require("mini.icons").setup()
require("mini.icons").tweak_lsp_kind()
require("mini.operators").setup()
require("mini.pairs").setup({ modes = { command = true, terminal = true } })
-- disable mini.pairs for markdown files
-- so that no extra ]s being inserted in links
local f = function(args)
  map("i", "[", "[", { buffer = args.buf })
end
vim.api.nvim_create_autocmd("Filetype", { pattern = "markdown", callback = f })
require("mini.splitjoin").setup()
require("mini.statusline").setup()
require("mini.surround").setup({ n_lines = 500, respect_selection_type = true, search_method = "cover_or_next" })
require("mini.tabline").setup()
require("mini.visits").setup()

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
nmap("-", function()
  if not files.close() then
    files.open(vim.api.nvim_buf_get_name(0))
  end
end, "open mini files")
-- open preview
nmap("<C-p>", function()
  files.refresh({ windows = { preview = true, width_preview = 80 } })
end, "enable file content preview")
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
  map("n", lhs, rhs, { buffer = buf_id, desc = desc })
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
f = function(args)
  vim.b[args.buf].miniindentscope_disable = true
end
vim.api.nvim_create_autocmd(
  "FileType",
  { pattern = { "mason", "checkhealth", "toggleterm", "markdown", "sidekick_terminal" }, callback = f }
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
nmap("<leader>fe", "<Cmd>Pick explorer<CR>", "explorer")
-- files
nmap("<leader>ff", function()
  pick.builtin.files()
end, "pick from files")
nmap("<leader>fo", function()
  extra.pickers.oldfiles()
end, "pick from old files")
nmap("<leader>fg", "<Cmd>Pick grep_live<CR>", "Grep live")
nmap("<leader>fG", '<Cmd>Pick grep pattern="<cword>"<CR>', "grep current word")
nmap("<leader>fa", function()
  extra.pickers.registers()
end, "pick from registers")
nmap("<leader>fm", '<Cmd>Pick git_hunks path="%"<CR>', "modified hunks (buf)")
-- neovim builtin
nmap("<leader>fh", "<Cmd>Pick help<CR>", "help tags")
nmap("<leader>fH", "<Cmd>Pick hl_groups<CR>", "highlight groups")
nmap("<leader>fc", "<Cmd>Pick git_commits<CR>", "commits (all)")
nmap("<leader>fC", "<Cmd>Pick git_commits path='%'<CR>", "commits (buf)")
-- buffer
nmap("<leader>fb", function()
  pick.builtin.buffers()
end, "buffers")
nmap("<leader>fL", '<Cmd>Pick buf_lines scope="all"<CR>', "Lines (all)")
nmap("<leader>fl", '<Cmd>Pick buf_lines scope="current"<CR>', "Lines (buf)")
nmap("<leader>fk", function()
  extra.pickers.keymaps()
end, "keymaps")
nmap("<leader>ft", function()
  extra.pickers.colorschemes()
end, "colorschemes")
nmap("<leader>fr", "<Cmd>Pick resume<CR>", "resume")
-- lsp
nmap("<leader>fR", '<Cmd>Pick lsp scope="references"<CR>', "references (lsp)")
nmap("<leader>fT", function()
  extra.pickers.lsp({ scope = "type_definition" })
end, "type definition (lsp)")
nmap("<leader>fw", '<Cmd>Pick lsp scope="workspace_symbol"<CR>', "symbols workspace")
nmap("<leader>fi", function()
  extra.pickers.lsp({ scope = "implementation" })
end, "implementation (lsp)")
nmap("<leader>fd", '<Cmd>Pick diagnostic scope="current"<CR>', "diagnostic buffer")
nmap("<leader>fD", '<Cmd>Pick diagnostic scope="all"<CR>', "diagnostic workspace")
nmap("<leader>fs", '<Cmd>Pick lsp scope="document_symbol"<CR>', "symbols document")
-- visits
nmap("<leader>fP", '<Cmd>Pick visit_paths cwd=""<CR>', "visit paths (all)")
nmap("<leader>fp", "<Cmd>Pick visit_paths<CR>", "visit paths (buf)")
nmap("<leader>fv", "<Cmd>Pick visit_labels cwd=''<CR>", "visit label (all)")
nmap("<leader>va", "<Cmd>lua MiniVisits.add_label()<CR>", "add visit label")
nmap("<leader>vd", "<Cmd>lua MiniVisits.remove_label()<CR>", "remove visit label")
nmap("<leader>f/", '<Cmd>Pick history scope="/"<CR>', '"/" history')
nmap("<leader>f;", '<Cmd>Pick history scope=":"<CR>', '":" history')

--> mini.sessions
local sessions = require("mini.sessions")
sessions.setup({
  autoread = true,
  verbose = { read = true },
})
local session_new = 'MiniSessions.write(vim.fn.input("Session name: "))'

nmap("<leader>sd", '<Cmd>lua MiniSessions.select("delete")<CR>', "[Session] Delete")
nmap("<leader>sc", "<Cmd>lua " .. session_new .. "<CR>", "[Session] New")
nmap("<leader>ss", '<Cmd>lua MiniSessions.select("read")<CR>', "[Session] Select")
nmap("<leader>sw", "<Cmd>lua MiniSessions.write()<CR>", "[Session] Write")

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
nmap("<leader>ts", cmd, "Trim all trailing whitespaces")
cmd = "<Cmd>lua MiniTrailspace.trim_last_lines()<CR>"
nmap("<leader>tl", cmd, "Trim all trailing empty lines")
