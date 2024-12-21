return {
  {
    -- fuzzy finder
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    cmd = 'Telescope',
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "nvim-telescope/telescope-frecency.nvim" },
    },
    config = function ()
      local tele = require('telescope')
      tele.load_extension('file_browser')
      tele.load_extension('frecency')
      tele.setup {
        defaults = {
          mappings = {
            i = {
              ["<C-h>"] = "which_key"
              -- ['<C-d>'] = false,
              -- ['<C-u>'] = false,
            },
          },
        },
        extensions = {
          file_browser = {
            -- theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
              ["i"] = {
                -- your custom insert mode mappings
              },
              ["n"] = {
                -- your custom normal mode mappings
              },
            },
          },
        },
      }
    end,
  },
}
