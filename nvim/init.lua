require("plugin/dpp")

-- denops shared server
-- vim.g.denops_server_addr = "127.0.0.1:34141"

-- denops debug flag
-- vim.g["denops#debug"] = 1

vim.g.mapleader = " "
vim.keymap.set('n', '<leader>pi', ":call dpp#async_ext_action('installer', 'install')<CR>")
vim.keymap.set('n', '<leader>pu', ":call dpp#async_ext_action('installer', 'update')<CR>")
