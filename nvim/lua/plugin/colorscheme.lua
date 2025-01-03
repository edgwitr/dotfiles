local MiniDeps = require('mini.deps')
-- MiniDeps.now(function ()
--   require('mini.hues').setup({ background = '#19213a', foreground = '#c4c6cd' }) -- blue
-- end)
MiniDeps.now(function ()
  -- https://github.com/sainnhe/sonokai/blob/master/alacritty/README.md shusia
  -- https://github.com/chriskempson/base16/blob/master/styling.md
  require('mini.base16').setup({
    palette = {
      -- Default Background
      base00 = "#2d2a2e",
      -- Lighter Background (Used for status bars, line number and folding marks)
      base01 = "#37343a",
      -- Selection Background
      base02 = "#423f46",
      -- Comments, Invisible, Line Highlighting
      base03 = "#848089",
      -- Dark Foreground (Used for status bars)
      base04 = "#66d9ef",
      -- Default Foreground, Caret, Delimiters, Operators
      base05 = "#e3e1e4",
      -- Light Foreground (Not often used)
      base06 = "#a1efe4",
      -- Light Background (Not often used)
      base07 = "#f8f8f2",
      -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      base08 = "#f85e84",
      -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
      base09 = "#ef9062",
      -- Classes, Markup Bold, Search Text Background
      base0A = "#a6e22e",
      -- Strings, Inherited Class, Markup Code, Diff Inserted
      base0B = "#e5c463",
      -- Support, Regular Expressions, Escape Characters, Markup Quotes
      base0C = "#66d9ef",
      -- Functions, Methods, Attribute IDs, Headings
      base0D = "#9ecd6f",
      -- Keywords, Storage, Selector, Markup Italic, Diff Changed
      base0E = "#a1efe4",
      -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
      base0F = "#f9f8f5",
    },
    use_cterm = true,
  })
end)

MiniDeps.later(function ()
  local hipatterns = require('mini.hipatterns')
  hipatterns.setup({
    highlighters = {
      -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
      fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
      hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
      todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
      note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },

      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)
