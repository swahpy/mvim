local blink = require "blink.cmp"

-- add neotab plugin in here, so that Tab key
-- will function well.
require("mini.deps").add {
  source = "kawre/neotab.nvim",
}
require("neotab").setup()

blink.setup {
  completion = {
    -- Show documentation when selecting a completion item
    documentation = {
      -- window = { border = "single" },
      auto_show = true,
      auto_show_delay_ms = 100,
    },
    list = {
      selection = {
        preselect = function(ctx)
          return ctx.mode ~= "cmdline" and not require("blink.cmp").snippet_active { direction = 1 }
        end,
      },
    },
    menu = {
      -- border = "single",
      draw = {
        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
        components = {
          kind_icon = {
            ellipsis = false,
            text = function(ctx)
              local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
              return kind_icon .. " "
            end,
            -- Optionally, you may also use the highlights from mini.icons
            highlight = function(ctx)
              local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
              return hl
            end,
          },
        },
      },
    },
  },
  keymap = {
    preset = "default",
    ["<C-c>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"] = { "hide", "fallback" },
    -- function(cmp)
    --   if cmp.snippet_active() then
    --     return cmp.accept()
    --   else
    --     return cmp.select_and_accept()
    --   end
    -- end,
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
    ["<A-k>"] = { "select_prev", "fallback" },
    ["<A-j>"] = { "select_next", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
  },
  signature = { enabled = true, window = { border = "single" } },
  sources = {
    default = {
      "lsp",
      "path",
      "snippets",
      "buffer",
      "markdown"
    },
    providers = {
      markdown = {
        name = "RenderMarkdown",
        module = "render-markdown.integ.blink",
        fallbacks = { "lsp" },
      },
    },
  },
}
