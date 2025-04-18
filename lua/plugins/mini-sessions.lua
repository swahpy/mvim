local session = require "mini.sessions"
session.setup {
  -- Whether to print session path after action
  verbose = { read = true },
}
