return {
  -- neotab
  {
    "kawre/neotab.nvim",
    event = "InsertEnter",
  },
  -- config blink keymap
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback_to_mappings" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback_to_mappings" },
        ["<M-k>"] = { "select_prev", "fallback" },
        ["<M-j>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "show", "fallback" },
        ["<C-c>"] = { "hide", "fallback" },
      },
    },
  },
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        ["*"] = function(_, _)
          LazyVim.lsp.on_attach(function(_, buffer)
            -- Set up 'mini.completion' LSP part of completion
            vim.bo[buffer].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
          end)
        end,
      },
    },
  },
  {
    "stevearc/oil.nvim",
    opts = {
      delete_to_trash = true, -- Delete files to trash instead of permanently
      keymaps = {
        ["h"] = { "actions.parent", mode = "n" },
        ["l"] = "actions.select",
        ["|"] = { "actions.select", opts = { vertical = true } },
        ["_"] = { "actions.select", opts = { horizontal = true } },
        ["gr"] = { "actions.open_cwd", mode = "n" },
        ["q"] = { "actions.close", mode = "n" },
      },
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      { "<leader>-", "<cmd>Oil --float<cr>", desc = "Open parent directory" },
    },
  },
  -- better escape
  -- {
  --   "max397574/better-escape.nvim",
  --   config = function()
  --     require("better_escape").setup()
  --   end,
  -- },
}
