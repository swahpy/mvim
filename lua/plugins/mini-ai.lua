local ai = require "mini.ai"
local spec = ai.gen_spec
local gen_ai_spec = require("mini.extra").gen_ai_spec
ai.setup {
  -- Number of lines within which textobject is searched
  n_lines = 500,
  custom_textobjects = {
    o = spec.treesitter { -- code block
      a = {
        "@block.outer",
        "@conditional.outer",
        "@loop.outer",
      },
      i = {
        "@block.inner",
        "@conditional.inner",
        "@loop.inner",
      },
    },
    -- Tweak function call to not detect dot in function name
    f = spec.function_call { name_pattern = "[%w_]" },

    -- Function definition (needs treesitter queries with these captures)
    F = spec.treesitter { a = "@function.outer", i = "@function.inner" },

    -- Make `|` select both edges in non-balanced way
    ["|"] = spec.pair("|", "|", { type = "non-balanced" }),

    -- class
    c = spec.treesitter {
      a = "@class.outer",
      i = "@class.inner",
    },

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
    B = gen_ai_spec.buffer(),
    D = gen_ai_spec.diagnostic(),
    I = gen_ai_spec.indent(),
    L = gen_ai_spec.line(),
    d = gen_ai_spec.number(),
    j = { "%f[^%c][^%c]*", "^%s*().-()%s*$" }, -- match whole line
  },
}
