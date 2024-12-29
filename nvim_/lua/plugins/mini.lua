return {
  {
    "echasnovski/mini.nvim",
    config = function()

      -- basic
      require('mini.basics').setup({
        -- options = {
        --   basic = false,
        -- },
        mappings = {
          windows = true,
          move_with_alt = true,
        },
        autocommands = {
          relnum_in_visual_mode = true,
        },
      })

      -- session
      require('mini.visits').setup()
      local MiniSessions = require('mini.sessions')
      MiniSessions.setup()
      vim.keymap.set('n', '<Leader>sw', function ()
        MiniSessions.write()
      end, { desc = '[S]ession [W]rite' })

      -- appearance
      -- colorscheme
      -- now(function ()
      --   require('mini.hues').setup({ background = '#19213a', foreground = '#c4c6cd' }) -- blue
      -- end)
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

      require('mini.starter').setup()
      require('mini.statusline').setup()
      require('mini.tabline').setup()
      require('mini.notify').setup()
      -- require('mini.animate').setup()
      -- require('mini.bufremove').setup()
      -- require('mini.clue').setup()
      require('mini.cursorword').setup()

      local MiniDiff = require('mini.diff')
      MiniDiff.setup({
        view = {
          style = 'sign',
          signs = { add = '+', change = '~', delete = '-' },
        },
      })
      vim.keymap.set('n', '<Leader>gd', function () MiniDiff.toggle_overlay() end, { desc = '[G]it [D]iff Toggle' })


      local MiniMap = require('mini.map')
      MiniMap.setup()
      vim.keymap.set('n', '<Leader>m', function ()
        MiniMap.toggle()
      end, { desc = '[M]ap Toggle' })

      local hipatterns = require('mini.hipatterns')
      hipatterns.setup({
        highlighters = {
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
          todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
          note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })

      local MiniIcons = require('mini.icons')
      MiniIcons.setup()
      MiniIcons.mock_nvim_web_devicons()

      -- editing
      -- require("mini.ai").setup()
      require("mini.align").setup()
      require('mini.splitjoin').setup()
      require("mini.pairs").setup()
      require("mini.surround").setup()
      require("mini.comment").setup()
      require('mini.move').setup()
      require("mini.trailspace").setup()
      require("mini.bracketed").setup() -- []
      require('mini.jump').setup() -- f, t
      require('mini.jump2d').setup() -- ^m
      require('mini.operators').setup()
      require('mini.misc').setup()
      require("mini.git").setup()
      -- require('mini.animate').setup()
      -- require('mini.bufremove').setup()
      require('mini.cursorword').setup()

      local MiniIndentscope = require('mini.indentscope')
      MiniIndentscope.setup({
        draw = {
          animation = MiniIndentscope.gen_animation.none()
        },
      })

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

      -- ????FIXME?????
      require('mini.fuzzy').setup()
      require('mini.pick').setup()
      require('mini.extra').setup()

      -- require('mini.completion').setup()
      -- require('mini.snippets').setup()

      local MiniFiles = require('mini.files')
      MiniFiles.setup { window = { preview = true } }
      vim.keymap.set('n', '<Leader>e', MiniFiles.open, { noremap = true, silent = true, desc = "[E]xplorer" })
      vim.keymap.set('n', '<Leader>E', function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0))
      end, { noremap = true, silent = true, desc = "[E]xplorer (current)" })
    end
  }
}
