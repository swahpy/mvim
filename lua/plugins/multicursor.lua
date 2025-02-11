local map = vim.keymap.set
local mc = require "multicursor-nvim"

mc.setup {}

-- Add or skip cursor above/below the main cursor.
map({ "n", "v" }, "<up>", function()
  mc.lineAddCursor(-1)
end)
map({ "n", "v" }, "<down>", function()
  mc.lineAddCursor(1)
end)
map({ "n", "v" }, "<leader><up>", function()
  mc.lineSkipCursor(-1)
end)
map({ "n", "v" }, "<leader><down>", function()
  mc.lineSkipCursor(1)
end)

-- Add and remove cursors with control + left click.
map("n", "<c-leftmouse>", mc.handleMouse)

map("n", "<esc>", function()
  if not mc.cursorsEnabled() then
    mc.enableCursors()
  elseif mc.hasCursors() then
    mc.clearCursors()
  else
    -- Default <esc> handler.
  end
end)

-- Append/insert for each line of visual selections.
map("v", "I", mc.insertVisual)
map("v", "A", mc.appendVisual)

-- Customize how cursors look.
local hl = vim.api.nvim_set_hl
hl(0, "MultiCursorCursor", { link = "Cursor" })
hl(0, "MultiCursorVisual", { link = "Visual" })
hl(0, "MultiCursorSign", { link = "SignColumn" })
hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
