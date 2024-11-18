local wezterm = require 'wezterm'

return {
  initial_rows = 36,
  initial_cols = 120,
  hide_tab_bar_if_only_one_tab = true,
  color_scheme = 'Materia (base16)',
  font_size = 13.0,
  default_prog = { "pwsh" },
  font = wezterm.font 'UDEV Gothic 35NFLG',
  enable_scroll_bar = true,
}
