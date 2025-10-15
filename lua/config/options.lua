local o = vim.opt

o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

-- UI =========================================================================
o.softtabstop = 2
o.shiftround = true -- Round indent
o.breakindent = true -- Indent wrapped lines to match line start
o.breakindentopt = "list:-1" -- Add padding for lists (if 'wrap' is set)
o.preserveindent = true
o.colorcolumn = "+1" -- Draw column on the right of maximum width
o.cursorline = true -- Enable current line highlighting
o.switchbuf = "usetab" -- Use already opened buffers when switching
o.linebreak = true -- Wrap lines at 'breakat' (if 'wrap' is set)
o.list = true -- Show helpful text indicators
o.number = true -- Show line numbers
o.relativenumber = true
o.pumheight = 10 -- Make popup menu smaller
o.ruler = false -- Don't show cursor coordinates
o.shortmess = "CFOSWaco" -- Disable some built-in completion messages
o.showmode = false -- Don't show mode in command line
o.signcolumn = "yes" -- Always show signcolumn (less flicker)
o.splitbelow = true -- Horizontal splits will be below
o.splitkeep = "screen" -- Reduce scroll during window split
o.splitright = true -- Vertical splits will be to the right
o.winborder = "single" -- Use border in floating windows
o.wrap = false -- Don't visually wrap lines (toggle with \w)
o.cursorlineopt = "screenline,number" -- Show cursor line per screen line

-- Special UI symbols. More is set via 'mini.basics' later.
o.fillchars = "eob: ,fold:╌"
o.listchars = "extends:…,nbsp:␣,precedes:…,tab:> "

-- Folds (see `:h fold-commands`, `:h zM`, `:h zR`, `:h zA`, `:h zj`)
o.foldlevel = 10 -- Fold nothing by default; set to 0 or 1 to fold
o.foldmethod = "indent" -- Fold based on indent level
o.foldnestmax = 10 -- Limit number of fold levels
vim.g.markdown_folding = 1

o.foldtext = "" -- Show text under fold with its highlighting

-- Editing ====================================================================
o.autoindent = true -- Use auto indent
o.expandtab = true -- Convert tabs to spaces
o.formatoptions = "rqnl1j" -- Improve comment editing
o.ignorecase = true -- Ignore case during search
o.incsearch = true -- Show search matches while typing
o.infercase = true -- Infer case in built-in completion
o.shiftwidth = 2 -- Use this number of spaces for indentation
o.smartcase = true -- Respect case if search pattern has upper case
o.smartindent = true -- Make indenting smart
o.spelloptions = "camel" -- Treat camelCase word parts as separate words
o.tabstop = 2 -- Show tab as this number of spaces
o.virtualedit = "block" -- Allow going past end of line in blockwise mode

o.iskeyword = "@,48-57,_,192-255,-" -- Treat dash as `word` textobject part

o.swapfile = false
o.undofile = true -- Enable persistent undo
o.autowrite = true -- Enable auto write

o.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

o.winblend = 0

o.mouse = "a" -- Enable mouse
o.mousescroll = "ver:20,hor:6"

-- Enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd("filetype plugin indent on")
if vim.fn.exists("syntax_on") ~= 1 then
  vim.cmd("syntax enable")
end

o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

o.iskeyword = "@,48-57,_,192-255,-" -- Treat dash separated words as a word text object

o.completeopt = "menuone,noselect,fuzzy,nosort"

if vim.fn.has("nvim-0.12") == 1 then
  vim.o.completefuzzycollect = "keyword,files,whole_line" -- Use fuzzy matching when collecting candidates
  require("vim._extui").enable({ enable = true })
  vim.keymap.set("c", "<Up>", "<C-u><Up>")
  vim.keymap.set("c", "<Down>", "<C-u><Down>")
end
