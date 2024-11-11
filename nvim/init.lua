local dpp_src = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp.vim"
-- プラグイン内のLuaモジュールを読み込むため、先にruntimepathに追加する必要があります。
vim.opt.runtimepath:prepend(dpp_src) 
local dpp = require("dpp")

local dpp_base = "~/.cache/dpp/"
local dpp_config = "~/.config/nvim/dpp.ts"

local denops_src = "$HOME/.cache/dpp/repos/github.com/vim-denops/denops.vim"

local ext_toml = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-ext-toml"
local ext_lazy = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-ext-lazy"
local ext_installer = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-ext-installer"
local ext_git = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-protocol-git"

vim.opt.runtimepath:append(ext_toml)
vim.opt.runtimepath:append(ext_git)
vim.opt.runtimepath:append(ext_lazy)
vim.opt.runtimepath:append(ext_installer)

-- denops shared serverの設定
-- vim.g.denops_server_addr = "127.0.0.1:34141"

-- denopsのデバッグフラグ
-- denopsプラグインの開発をしない場合は0(デフォルト)にしてください
-- vim.g["denops#debug"] = 1

if dpp.load_state(dpp_base) then
  vim.opt.runtimepath:prepend(denops_src)

  vim.api.nvim_create_autocmd("User", {
	  pattern = "DenopsReady",
  	callback = function ()
		vim.notify("vim load_state is failed")
  		dpp.make_state(dpp_base, dpp_config)
  	end
  })
end

vim.g.mapleader = " "
vim.keymap.set('n', '<leader>pi', ":call dpp#async_ext_action('installer', 'install')<CR>")
vim.keymap.set('n', '<leader>pu', ":call dpp#async_ext_action('installer', 'update')<CR>")
vim.api.nvim_create_user_command('Denossin', function()
	vim.cmd('call denops_shared_server#install()')
end, {})
vim.api.nvim_create_user_command('Denossun', function()
	vim.cmd('call denops_shared_server#uninstall()')
end, {})
