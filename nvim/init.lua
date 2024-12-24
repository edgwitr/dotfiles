-- require("config.option")
-- require("config.autocmd")
-- require("config.lazy")
-- require("config.netrw")

-- Put this at the top of 'init.lua'
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    -- Uncomment next line to use 'stable' branch
    -- '--branch', 'stable',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
end


MiniDeps = require('mini.deps')
MiniDeps.setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add("echasnovski/mini.nvim")

-- colorscheme
now(function()
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

-- basic_settings
now(function()
  require('mini.basics').setup({
    mappings = {
      windows = true,
      move_with_alt = true,
    },
    autocommands = {
      relnum_in_visual_mode = true,
    },
  })
  vim.wo.relativenumber = true
end)

now(function()
    require('mini.statusline').setup()
end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.files').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.trailspace').setup() end)
now(function() require('mini.bracketed').setup() end)
later(function()
    require('mini.diff').setup({
      view = {
        style = 'sign',
        signs = { add = '+', change = '~', delete = '_' },
      },
    })
end)
later(function() require('mini.git').setup() end)

now(function()
  local MiniIcons = require('mini.icons')
  MiniIcons.setup()
  MiniIcons.mock_nvim_web_devicons()
end)

later(function() require('mini.indentscope').setup() end)
later(function() require('mini.completion').setup() end)
later(function() require('mini.splitjoin').setup() end)

-- -- Define helpers
-- local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
-- local opts = { noremap = true, silent = true }

-- now(function()
-- 	-- ファイラー
-- 	require('mini.files').setup { window = { preview = true } }
-- 	vim.keymap.set('n', '<Leader>e', MiniFiles.open, opts)
-- 	vim.keymap.set('n', '<Leader>E', function()
-- 		MiniFiles.open(vim.api.nvim_buf_get_name(0))
-- 	end, opts)
-- end)
-- require("plugin.base16")
