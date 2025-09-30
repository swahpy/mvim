vim.pack.add({
  "https://github.com/obsidian-nvim/obsidian.nvim",
})

require("obsidian").setup({
  legacy_commands = false,
  notes_subdir = "notes",
  note_id_func = function(title)
    local suffix = ""
    if title ~= nil then
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    return tostring(os.time()) .. "-" .. suffix
  end,
  wiki_link_func = require("obsidian.builtin").wiki_link_path_only,
  workspaces = {
    { name = "swahpy", path = "~/workspace/vaults/swahpy" },
    -- {
    --   name = "no-vault",
    --   path = function()
    --     -- alternatively use the CWD:
    --     -- return assert(vim.fn.getcwd())
    --     return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
    --   end,
    --   overrides = {
    --     notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
    --     new_notes_location = "current_dir",
    --     templates = {
    --       folder = vim.NIL,
    --     },
    --     disable_frontmatter = true,
    --   },
    -- },
  },
  daily_notes = {
    folder = "dailies",
    date_format = "%Y-%m-%d",
    alias_format = "%B %-d, %Y",
    workdays_only = false,
  },
  templates = {
    folder = "templates",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M",
    substitutions = {},
  },
})

local map = vim.keymap.set

map({ "n", "v" }, "<leader>on", "<cmd>Obsidian new<cr>", { desc = "Create a new note" })
map({ "n", "v" }, "<leader>ot", "<cmd>Obsidian today<cr>", { desc = "Create or Open today daily-note" })
map({ "n", "v" }, "<leader>oy", "<cmd>Obsidian yesterday<cr>", { desc = "Create or Open yesterday daily-note" })
map({ "n", "v" }, "<leader>oT", "<cmd>Obsidian tomorrow<cr>", { desc = "Create or Open tomorrow daily-note" })
