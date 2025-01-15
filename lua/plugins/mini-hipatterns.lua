local hipatterns = require "mini.hipatterns"
hipatterns.setup {
  highlighters = {
    -- Highlight standalone 'fixme', 'hack', 'todo', 'note'
    fixme = { pattern = "#()fixme()", group = "MiniHipatternsFixme" },
    hack = { pattern = "#()hack()", group = "MiniHipatternsHack" },
    todo = { pattern = "#()todo()", group = hipatterns.compute_hex_color_group('#C85552', "fg") },
    note = { pattern = "#()note()", group = hipatterns.compute_hex_color_group('#F7954F', "fg") },
    done = { pattern = "#()done()", group = hipatterns.compute_hex_color_group('#5DA111', "fg") },
    -- #todo #done #note
    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
}
