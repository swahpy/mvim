local animate = require "mini.animate"
animate.setup {
  cursor = {
    timing = animate.gen_timing.linear { duration = 50, unit = "total" },
  },
  scroll = {
    timing = animate.gen_timing.linear { duration = 100, unit = "total" },
    subscroll = animate.gen_subscroll.equal { max_output_steps = 80 },
  },
}
