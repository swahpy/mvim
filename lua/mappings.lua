local map = vim.keymap.set

map({ "n", "v" }, ";", ":", { desc = "CMD enter command mode" })

map({ "n", "i", "v" }, "<A-w>", "<cmd> w <cr><Esc>")

map("n", "c", '"_c', { desc = "change without yanking" })
map("n", "C", '"_C', { desc = "change without yanking" })

-- move
map("i", "<C-a>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })

map({ "n", "x", "v" }, "gb", "^", { desc = "move to beginning character of current line" })
map({ "n", "x", "v" }, "ge", "$", { desc = "move to ending character of current line" })

-- tab keymaps
map("n", "<S-l>", function()
  vim.cmd "bnext"
end, { desc = "navigate to next buffer" })
map("n", "<S-h>", function()
  vim.cmd "bprev"
end, { desc = "navigate to previous buffer" })
map("n", "<A-1>", function()
  vim.cmd "bfirst"
end, { desc = "navigate to previous buffer" })
map("n", "<A-0>", function()
  vim.cmd "blast"
end, { desc = "navigate to previous buffer" })

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

--> mini mappings <--
-- mini.diff
local rhs = "<cmd>lua MiniDiff.toggle_overlay()<cr>"
map("n", "<leader>do", rhs, { desc = "toggle mini.diff overlay" })
-- mini.git
rhs = "<Cmd>lua MiniGit.show_at_cursor()<CR>"
map({ "n", "x" }, "<Leader>gs", rhs, { desc = "Show at cursor" })
-- mini.trailspace
rhs = "<cmd>lua MiniTrailspace.trim()<cr>"
map("n", "<leader>ts", rhs, { desc = "Trim all trailing whitespaces" })
rhs = "<Cmd>lua MiniTrailspace.trim_last_lines()<CR>"
map("n", "<leader>tl", rhs, { desc = "Trim all trailing empty lines" })
-- mini.bufremove
map("n", "<leader>nb", [[ <cmd> enew <cr> ]], { desc = "create a new buffer" })
rhs = "<Cmd>lua MiniBufremove.delete()<CR>"
map("n", "<leader>x", rhs, { desc = "delete current buffer using :bdelete" })
rhs = "<Cmd>lua MiniBufremove.unshow()<CR>"
map("n", "<leader>us", rhs, { desc = "stop showing current buffer in all windows" })
-- mini.jump2d
map("n", "sl", "<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.line_start)<CR>")
map("n", "sw", "<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.word_start)<CR>")
map("n", "sc", "<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<CR>")
map("n", "sp", function()
  ---@diagnostic disable-next-line: undefined-global
  MiniJump2d.start {
    ---@diagnostic disable-next-line: undefined-global
    spotter = MiniJump2d.gen_pattern_spotter "%p+",
    hl_group = "Search",
  }
end)
map("n", "sP", function()
  ---@diagnostic disable-next-line: undefined-global
  MiniJump2d.start {
    ---@diagnostic disable-next-line: undefined-global
    spotter = MiniJump2d.gen_pattern_spotter "%p+",
    allowed_lines = { cursor_before = false, cursor_after = false },
    allowed_windows = { not_current = false },
    hl_group = "Search",
  }
end)
map("n", "sC", function()
  ---@diagnostic disable-next-line: undefined-global
  MiniJump2d.start {
    ---@diagnostic disable-next-line: undefined-global
    spotter = MiniJump2d.gen_pattern_spotter "%[%^%d%]",
    hl_group = "Search",
  }
end)
-- mini.misc
map("n", "<leader>zz", "<cmd>lua MiniMisc.zoom()<cr>", { desc = "zoom in/out buffer" })
-- mini.notify
map("n", "<leader>nh", "<cmd>lua MiniNotify.show_history()<cr>", { desc = "show notification history" })
map("n", "<leader>cn", "<cmd>lua MiniNotify.clear()<cr>", { desc = "remove all active notifications" })
-- mini.visits
map("n", "-", "<cmd>lua MiniVisits.add_label()<cr>", { desc = "Add label" })
map("n", "<leader>-", "<cmd>lua MiniVisits.remove_label()<cr>", { desc = "Remove label" })
-- mini.sessions
local session = require "mini.sessions"
map("n", "<leader>rs", function()
  local sessions = {}
  local keystr = ""
  local n = 0
  for k, _ in pairs(session.detected) do
    n = n + 1
    sessions[n] = k
    keystr = keystr .. n .. ": " .. k .. "\n"
  end
  local numstr =
    vim.fn.input("Below are current sessions, please select the one to delete(1/2/...):\n" .. keystr .. "\n> ")
  if numstr == "" then
    return
  end
  local num = tonumber(numstr)
  if num <= n then
    session.delete(sessions[num])
  else
    print "Wrong session number!"
  end
end, { desc = "remove a session" })
map("n", "<leader>cs", [[<cmd>lua =vim.v.this_session<cr>]], { desc = "show current session" })
map("n", "<leader>ls", [[<cmd>lua MiniSessions.select()<cr>]], { desc = "show current session" })

--> non-mini plugins mappings <--
map("n", "<leader>ut", "<cmd>UndotreeToggle<cr>", { desc = "Toggle undo tree" })
