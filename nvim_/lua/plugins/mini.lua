return {
  "echasnovski/mini.nvim",
  config = function()
    vim.wo.relativenumber = true
    require('mini.basics').setup({
      mappings = {
        windows = true,
        move_with_alt = true,
      },
      autocommands = {
        relnum_in_visual_mode = true,
      },
    })

    require('mini.sessions').setup()
    vim.keymap.set('n', '<Leader>sw', function ()
      require('mini.sessions').write()
    end, { desc = '[S]ession [W]rite' })

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
    require('mini.visits').setup()
    require('mini.statusline').setup()
    require('mini.tabline').setup()
    require('mini.notify').setup()

    -- require("mini.ai").setup()
    require("mini.align").setup()
    require('mini.splitjoin').setup()
    require("mini.visits").setup()
    require("mini.pairs").setup()
    require("mini.comment").setup()
    require('mini.move').setup()
    require("mini.surround").setup()
    require("mini.trailspace").setup()
    require("mini.bracketed").setup() -- []
    require('mini.jump').setup() -- f, t
    require('mini.jump2d').setup() -- ^m
    require('mini.operators').setup()
    -- require('mini.misc').setup()
    require("mini.git").setup()
    local MiniIcons = require('mini.icons')
    MiniIcons.setup()
    MiniIcons.mock_nvim_web_devicons()
    -- require('mini.animate').setup()
    -- require('mini.bufremove').setup()
    require('mini.cursorword').setup()
    require('mini.map').setup()
    vim.keymap.set('n', '<Leader>mm', function () require('mini.map').toggle() end, { desc = '[M]ap' })
    vim.keymap.set('n', '<Leader>mr', function () require('mini.map').refresh() end, { desc = '[M]ap [R]efresh' })

    local MiniIndentscope = require('mini.indentscope')
    MiniIndentscope.setup({
      draw = {
        delay = 20,
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
    require('mini.fuzzy').setup()
    require('mini.pick').setup()
    require('mini.extra').setup()

    local MiniFiles = require('mini.files')
    MiniFiles.setup { window = { preview = true } }
    vim.keymap.set('n', '<Leader>e', MiniFiles.open, { noremap = true, silent = true, desc = "[E]ditor" })
    vim.keymap.set('n', '<Leader>E', function()
      MiniFiles.open(vim.api.nvim_buf_get_name(0))
    end, { noremap = true, silent = true, desc = "[E]ditor (current)" })
  end
}
