local snippets = require "mini.snippets"
local gen_loader = snippets.gen_loader
local map = vim.keymap.set

local match_strict = function(snips)
  -- Do not match with whitespace to cursor's left
  return snippets.default_match(snips, { pattern_fuzzy = "%S+" })
end

snippets.setup {
  -- Array of snippets and loaders (see |snippets.config| for details).
  -- Nothing is defined by default. Add manually to have snippets to match.
  snippets = {
    -- Load custom file with global snippets first
    gen_loader.from_file "~/.config/nvim/snippets/global.json",

    -- Load snippets based on current language by reading files from
    -- "snippets/" subdirectories from 'runtimepath' directories.
    gen_loader.from_lang(),
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = { jump_next = "<Tab>", jump_prev = "<S-Tab>" },
  expand = {
    match = match_strict,
  },
}
