return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    event = {'BufNewFile', 'BufRead'},
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/nvim-treesitter-refactor',
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'c', 'cpp', 'rust', 'c_sharp', 'fsharp', 'haskell', 'go',
          'lua', 'python', 'ruby', 'java', 'kotlin', 'scala',
          'html', 'css', 'tsx', 'javascript', 'typescript',
          'vimdoc', 'vim', 'bash', 'json', 'yaml', 'toml', 'powershell',
          'regex','markdown',
        },
        highlight = { enable = true },
        indent = { enable = true },

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
      }
    end
  },
}
