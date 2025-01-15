require("render-markdown").setup {
  render_modes = { "n", "c", "t", "i" },
  heading = {
    position = "inline",
    width = "block",
    left_margin = { 0.5, 0 },
  },
  code = {
    sign = "language",
    width = "block",
    min_width = 80,
  },
}
