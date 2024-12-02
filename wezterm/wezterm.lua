local wezterm = require 'wezterm'

return {
  initial_rows = 36,
  initial_cols = 120,
  hide_tab_bar_if_only_one_tab = true,
  font_size = 14.0,
  default_prog = { "pwsh" },
  font = wezterm.font "MonaspiceNe Nerd Font",
  enable_scroll_bar = true,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
}
