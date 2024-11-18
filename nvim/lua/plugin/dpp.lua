local dpp_base = vim.fn.stdpath("cache") .. "/dpp"

vim.notify(dpp_base, vim.log.levels.INFO)

local dpp_config = vim.fn.stdpath("config") .. "/lua/plugin/dpp.ts"

local dpp_src = dpp_base .. "/repos/github.com/Shougo/dpp.vim"
vim.opt.runtimepath:prepend(dpp_src) 
if not vim.loop.fs_stat(dpp_src) then
	vim.fn.system({
		"git",
		"clone",
		"git@github.com:Shougo/dpp.vim.git",
		dpp_src
	})
end
local dpp = require("dpp")

local denops_src = dpp_base .. "/repos/github.com/vim-denops/denops.vim"
if not vim.loop.fs_stat(denops_src) then
	vim.fn.system({
		"git",
		"clone",
		"git@github.com:vim-denops/denops.vim.git",
		denops_src
	})
end


local ext_toml = dpp_base .. "/repos/github.com/Shougo/dpp-ext-toml"
vim.opt.runtimepath:append(ext_toml)
if not vim.loop.fs_stat(ext_toml) then
	vim.fn.system({
		"git",
		"clone",
		"git@github.com:Shougo/dpp-ext-toml.git",
		ext_toml
	})
end

local ext_lazy = dpp_base .. "/repos/github.com/Shougo/dpp-ext-lazy"
vim.opt.runtimepath:append(ext_lazy)
if not vim.loop.fs_stat(ext_lazy) then
	vim.fn.system({
		"git",
		"clone",
		"git@github.com:Shougo/dpp-ext-lazy.git",
		ext_lazy
	})
end
local ext_installer = dpp_base .. "/repos/github.com/Shougo/dpp-ext-installer"
vim.opt.runtimepath:append(ext_installer)
if not vim.loop.fs_stat(ext_installer) then
	vim.fn.system({
		"git",
		"clone",
		"git@github.com:Shougo/dpp-ext-installer.git",
		ext_installer
	})
end

local ext_git = dpp_base .. "/repos/github.com/Shougo/dpp-protocol-git"
vim.opt.runtimepath:append(ext_git)
if not vim.loop.fs_stat(ext_git) then
	vim.fn.system({
		"git",
		"clone",
		"git@github.com:Shougo/dpp-protocol-git.git",
		ext_git
	})
end



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
