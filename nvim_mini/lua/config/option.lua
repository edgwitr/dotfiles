-- basics
require("mini.deps").now(function ()
  require('mini.basics').setup({
    mappings = {
      windows = true,
      move_with_alt = true,
    },
    autocommands = {
      relnum_in_visual_mode = true,
    },
  })
end)
-- indent
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.shiftwidth = 2

-- save history
vim.o.undofile = true
vim.opt.list = true

-- space
vim.opt.listchars = {
  -- space = '.',
  tab = '>>',
  trail = '-',
  nbsp = '+',
  eol = '$',
}

vim.api.nvim_create_augroup('extra-whitespace', {})
vim.api.nvim_create_autocmd({'VimEnter', 'WinEnter'}, {
    group = 'extra-whitespace',
    pattern = {'*'},
    command = [[call matchadd('ExtraWhitespace', '[\u00A0\u2000-\u200B\u3000]')]]
})
vim.api.nvim_create_autocmd({'ColorScheme'}, {
    group = 'extra-whitespace',
    pattern = {'*'},
    command = [[highlight default ExtraWhitespace ctermbg=202 ctermfg=202 guibg=salmon]]
})
