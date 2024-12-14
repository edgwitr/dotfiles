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
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "debugloop/telescope-undo.nvim" },
    },
    config = function ()
      local tele = require('telescope')
      tele.setup {

        defaults = {
          mappings = {
            i = {
              ['<C-d>'] = false,
              ['<C-u>'] = false,
            },
          },
        },
        extensions = {
          file_browser = {
            theme = "ivy",
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

      tele.load_extension('undo')
      tele.load_extension('file_browser')
      tele.load_extension('live_grep_args')
    end,
  },
}
