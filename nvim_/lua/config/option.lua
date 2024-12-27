-- set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- -- row number
-- vim.wo.number = true
vim.wo.relativenumber = true

-- -- keep space for signcolumn
-- vim.wo.signcolumn = 'yes'

-- vim.o.mouse = ''

-- -- keep indent when break
-- vim.o.breakindent = true
-- vim.o.autoindent = true
-- vim.o.smartindent = true
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.shiftwidth = 2

-- vim.o.cursorline = true
vim.o.clipboard = "unnamedplus"

-- save history
vim.o.undofile = true
-- -- Case-insensitive searching UNLESS \C or capital in search
-- vim.o.smartcase = true
-- vim.o.incsearch = true

-- -- completion settings
-- vim.o.completeopt = 'menuone,noselect'
-- -- completion count
-- vim.o.pumheight = 10

vim.opt.list = true
vim.opt.listchars = {
  space = '.',
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

