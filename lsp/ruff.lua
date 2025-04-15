return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "ruff.toml",
    ".ruff.toml",
  },
  trace = "messages",
  init_options = {
    settings = {
      logLevel = "debug",
    },
  },
}
