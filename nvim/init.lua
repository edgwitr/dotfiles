-- local local_config = vim.fn.stdpath("config") .. "/local.lua"
-- local file = io.open(local_config, "r")

-- if file then
--   io.close(file)
--   dofile(local_config)
-- end

-- require("plugin/dpp")

-- -- denops shared server
-- -- vim.g.denops_server_addr = "127.0.0.1:34141"

-- -- denops debug flag
-- -- vim.g["denops#debug"] = 1

-- vim.g.mapleader = " "
-- vim.keymap.set('n', '<leader>pi', ":call dpp#async_ext_action('installer', 'install')<CR>")
-- vim.keymap.set('n', '<leader>pu', ":call dpp#async_ext_action('installer', 'update')<CR>")
-- vim.api.nvim_create_user_command('Denossin', function()
-- 	vim.cmd('call denops_shared_server#install()')
-- end, {})
-- vim.api.nvim_create_user_command('Denossun', function()
-- 	vim.cmd('call denops_shared_server#uninstall()')
-- end, {})

require("config.option")
require("config.autocmd")
require("config.lazy")
