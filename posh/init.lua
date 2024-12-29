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

local MiniDeps = require('mini.deps')
MiniDeps.setup({ path = { package = path_package } })
vim.keymap.set('n', '<Leader>pu', ":DepsUpdate<CR>", { desc = '[P]lugin [U]pdate' })
vim.keymap.set('n', '<Leader>pc', ":DepsUpdate<CR>", { desc = '[P]lugin [C]lean' })


local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- core
add("echasnovski/mini.nvim")

-- basics
now(function ()
  require('mini.basics').setup({
    mappings = {
      windows = true,
      move_with_alt = true,
    },
  })
  vim.wo.relativenumber = true
end)
now(function ()
  require('mini.sessions').setup()
  vim.keymap.set('n', '<Leader>sw', function ()
    require('mini.sessions').write()
  end, { desc = '[S]ession [W]rite' })
end)

-- treesitter
later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
    depends = {
      {
        source = 'nvim-treesitter/nvim-treesitter',
        checkout = 'master',
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
      },
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/nvim-treesitter-refactor',
    }
  })

  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'lua'
    },
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = { enable = false },
    refactor = {
      highlight_current_scope = { enable = true },
      highlight_definitions = {
        enable = true,
        -- Set to false if you have an `updatetime` of ~100.
        clear_on_cursor_move = true,
      },
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
    },
  })

  -- Disable injections in 'lua' language. In Neovim<0.9 it is
  -- `vim.treesitter.query.set_query()`; in Neovim>=0.9 it is
  -- `vim.treesitter.query.set()`.
  local ts_query = require('vim.treesitter.query')
  local ts_query_set = ts_query.set or ts_query.set_query
  ts_query_set('lua', 'injections', '')
end)

-- appearance
-- colorscheme
-- now(function ()
--   require('mini.hues').setup({ background = '#19213a', foreground = '#c4c6cd' }) -- blue
-- end)
now(function ()
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
now(function ()
  local MiniIcons = require('mini.icons')
  MiniIcons.setup()
  MiniIcons.mock_nvim_web_devicons()
end)
now(function () require('mini.starter').setup() end)
now(function () require('mini.statusline').setup() end)
now(function () require('mini.tabline').setup() end)
now(function () require('mini.notify').setup() end)

-- later(function() require('mini.animate').setup() end)
-- later(function() require('mini.bufremove').setup() end)
later(function () require('mini.cursorword').setup() end)
later(function()
  require('mini.map').setup()
  vim.keymap.set('n', '<Leader>mm', function ()
    require('mini.map').toggle()
  end, { desc = '[M]ap' })
  vim.keymap.set('n', '<Leader>mr', function ()
    require('mini.map').refresh()
  end, { desc = '[M]ap [R]efresh' })
end)
later(function () require('mini.trailspace').setup() end)

later(function ()
  require('mini.diff').setup({
    view = {
      style = 'sign',
      signs = { add = '+', change = '~', delete = '-' },
    },
  })
end)

-- view color
later(function ()
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

-- view indent
later(function ()
  local MiniIndentscope = require('mini.indentscope')
  MiniIndentscope.setup({
    draw = {
      animation = MiniIndentscope.gen_animation.none()
    },
  })
end)

-- selector
later(function () require('mini.fuzzy').setup() end)
later(function () require('mini.pick').setup() end)
later(function () require('mini.extra').setup() end)

-- filer
now(function ()
  local MiniFiles = require('mini.files')
  MiniFiles.setup { window = { preview = true } }
  vim.keymap.set('n', '<Leader>e', MiniFiles.open, { noremap = true, silent = true, desc = "[E]ditor" })
  vim.keymap.set('n', '<Leader>E', function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
  end, { noremap = true, silent = true, desc = "[E]ditor (current)" })
end)

-- editing
later(function () require('mini.pairs').setup() end)
later(function () require('mini.surround').setup() end)

later(function()
  add({
    source = 'williamboman/mason-lspconfig.nvim',
    depends = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    }
  })
  local mason = require('mason')
  mason.setup({
    ui = {
      icons = {
        package_installed = "v",
        package_pending = ">",
        package_uninstalled = "x"
      }
    }
  })

  local servers = {
    powershell_es = {},
    lua_ls = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  }
  local function is_cargo()
    local os_name = os.getenv("OS") or ""
    if os_name:match("Windows_NT") then
      local result = os.execute("where.exe cargo.exe > nul 2>&1")
      return result == 0
    else
      local result = os.execute("command -v cargo > /dev/null 2>&1")
      return result == 0
    end
  end
  if is_cargo() then
    servers.nil_ls = {}
  end
  require("mason-lspconfig").setup {
    ensure_installed = servers,
  }

  local lspconfig = require('lspconfig')
  lspconfig.powershell_es.setup{}
  lspconfig.lua_ls.setup {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using
          -- (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT'
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME
            -- Depending on the usage, you might want to add additional paths here.
            -- "${3rd}/luv/library"
            -- "${3rd}/busted/library",
          }
          -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
          -- library = vim.api.nvim_get_runtime_file("", true)
        }
      })
    end,
    settings = {
      Lua = {}
    }
  }
end)
later(function () require('mini.completion').setup() end)
later(function () require('mini.snippets').setup() end)

later(function () require('mini.align').setup() end)
later(function () require('mini.splitjoin').setup() end)
later(function () require('mini.comment').setup() end)
later(function () require('mini.move').setup() end)
-- later(function() require('mini.misc').setup() end)

-- navigation
-- later(function() require('mini.ai').setup() end)
later(function () require('mini.bracketed').setup() end) -- []
later(function () require('mini.jump').setup() end) -- f, t
later(function () require('mini.jump2d').setup() end) -- ^m
later(function () require('mini.operators').setup() end)
later(function () require('mini.git').setup() end)
-- later(function () require('mini.clue').setup() end)
add("folke/which-key.nvim")
later(function () require('mini.visits').setup() end)
