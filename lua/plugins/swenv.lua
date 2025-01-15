local map = vim.keymap.set

require("swenv").setup {
  venvs_path = vim.fn.expand "~/.pyenv/versions/3.13.1/envs",
}
map("n", "<leader>pv", function()
  require("swenv.api").pick_venv()
end, { desc = "pick a python virtual env" })
map("n", "<leader>cv", function()
  local venv = require("swenv.api").get_current_venv()
  if venv ~= nil then
    print(venv.name)
  else
    print "no virtual env selected so far!"
  end
end, { desc = "print current python virtual env" })
