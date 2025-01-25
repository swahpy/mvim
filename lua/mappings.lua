local map = vim.keymap.set

map({ "n", "v" }, ";", ":", { desc = "CMD enter command mode" })

map({ "n", "i", "v" }, "<A-w>", "<cmd> w <cr><Esc>")

-- move
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })

map("n", "gb", "^", { desc = "move to beginning character of current line" })
map("n", "ge", "$", { desc = "move to endding character of current line" })

-- tab keymaps
map("n", "<S-l>", function()
  vim.cmd "bnext"
end, { desc = "navigate to next buffer" })
map("n", "<S-h>", function()
  vim.cmd "bprev"
end, { desc = "navigate to previous buffer" })
map("n", "<leader>bc", function()
  local current_buf = vim.api.nvim_get_current_buf()
  -- Get a list of all open buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    -- Skip the current buffer and buffers that are unloaded or hidden
    if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
  vim.cmd "redrawtabline"
end, { desc = "close all buffers except current" })

-- toggle checkbox
local toggle_checkbox = function()
  local line = vim.api.nvim_get_current_line()
  if line:match "^%s*%-%s%[%s%]%s*" then
    line = line:gsub("^%s*%-%s%[%s%]%s*", "- [x] "):gsub("#todo", "#done")
  elseif line:match "^%s*%-%s%[x%]%s*" then
    line = line:gsub("^(%s*%-%s%[x%]%s*)", "- [ ] "):gsub("#done", "#todo")
  elseif not line:match "^%s*%-%s%[.*%]%s*" then
    line = "- [ ] " .. line .. " #todo"
  end
  vim.api.nvim_set_current_line(line)
end

-- toggle checkbox with todo or done tag
map("n", "<leader>cb", function()
  toggle_checkbox()
end, { desc = "toggle checkbox" })

-- open link under cursor
map({ "n", "v" }, "<leader>L", function()
  local url = vim.fn.expand "<cfile>"
  if url:match "^https?://" then
    vim.ui.open(url)
  else
    print "No URL found under the cursor."
  end
end, { desc = "open link under cursor" })

-- check current root directory
map("n", "<leader>rd", function()
  print(vim.fn.expand "%:p")
end, { desc = "print root directory" })
