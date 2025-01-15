local files = require "mini.files"
local map = vim.keymap.set
local cmd = vim.api.nvim_create_autocmd

files.setup {
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
}

-- toggle files
map("n", "<C-n>", function(...)
  if not files.close() then
    files.open(...)
  end
end, { desc = "open mini files" })
map("n", "<leader>e", function()
  if not files.close() then
    files.open(vim.api.nvim_buf_get_name(0))
  end
end, { desc = "open mini files" })

map("n", "<leader>fp", function()
  files.refresh { windows = { preview = true, width_preview = 80 } }
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
  files.refresh { content = { filter = new_filter } }
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
      files.go_in { close_on_file = close_on_file }
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

    map_split(buf_id, "-", "horizontal", false)
    map_split(buf_id, "|", "vertical", false)
  end,
})

-- set custom bookmarks
local set_mark = function(id, path, desc)
  files.set_bookmark(id, path, { desc = desc })
end
cmd("User", {
  pattern = "filesExplorerOpen",
  callback = function()
    set_mark("c", vim.fn.stdpath "config", "Config") -- path
    set_mark("w", vim.fn.getcwd, "Working directory") -- callable
    set_mark("~", "~", "Home directory")
  end,
})
