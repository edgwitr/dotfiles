-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- lazy
vim.keymap.set('n', '<Leader>pl', ":Lazy<CR>", { desc = '[P]lugin [L]azy' })
-- lazy update
vim.keymap.set('n', '<Leader>pu', ":Lazy update<CR>", { desc = '[P]lugin [U]pdate' })
-- lazy profile
vim.keymap.set('n', '<Leader>pp', ":Lazy profile<CR>", { desc = '[P]lugin [P]rofile' })
-- lazy clean
vim.keymap.set('n', '<Leader>pc', ":Lazy clean<CR>", { desc = '[P]lugin [C]lean' })
