local session = require "mini.sessions"
session.setup {
  -- Whether to print session path after action
  verbose = { read = true },
}
local map = vim.keymap.set
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
