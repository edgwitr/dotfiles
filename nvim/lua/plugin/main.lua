local MiniDeps = require('mini.deps')

vim.keymap.set('n', '<Leader>pu', function () MiniDeps.update() end, { desc = '[P]lugin [U]pdate' })
vim.keymap.set('n', '<Leader>pc', function () MiniDeps.clean() end, { desc = '[P]lugin [C]lean' })

MiniDeps.later(function () require('mini.visits').setup() end)
MiniDeps.now(function ()
  require('mini.sessions').setup()
  vim.keymap.set('n', '<Leader>sw', function ()
    require('mini.sessions').write()
  end, { desc = '[S]ession [W]rite' })
end)

-- appearance
MiniDeps.now(function ()
  local MiniIcons = require('mini.icons')
  MiniIcons.setup()
  MiniIcons.mock_nvim_web_devicons()
end)
MiniDeps.now(function () require('mini.starter').setup() end)
MiniDeps.now(function () require('mini.statusline').setup() end)
MiniDeps.now(function () require('mini.tabline').setup() end)
MiniDeps.now(function () require('mini.notify').setup() end)
-- MiniDeps.now(function () require('mini.clue').setup() end)
MiniDeps.add("folke/which-key.nvim")

-- MiniDeps.later(function() require('mini.animate').setup() end)
MiniDeps.later(function() require('mini.bufremove').setup() end)
MiniDeps.later(function () require('mini.cursorword').setup() end)
MiniDeps.later(function()
  local MiniMap = require("mini.map")
  MiniMap.setup()
  vim.keymap.set('n', '<Leader>omv', function () MiniMap.toggle() end, { desc = '[OTHER][M]ap [V]iew' })
  vim.keymap.set('n', '<Leader>omr', function () MiniMap.refresh() end, { desc = '[M]ap [R]efresh' })
end)
MiniDeps.later(function () require('mini.trailspace').setup() end)

-- view indent
MiniDeps.later(function ()
  local MiniIndentscope = require('mini.indentscope')
  MiniIndentscope.setup({
    symbol = ':';
    draw = {
      animation = MiniIndentscope.gen_animation.none()
    },
  })
end)

-- filer
MiniDeps.now(function ()
  local MiniFiles = require('mini.files')
  MiniFiles.setup { window = { preview = true } }
  vim.keymap.set('n', '<Leader>e', MiniFiles.open, { noremap = true, silent = true, desc = "[E]ditor" })
  vim.keymap.set('n', '<Leader>E', function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
  end, { noremap = true, silent = true, desc = "[E]ditor (current)" })
end)

-- editing
MiniDeps.later(function () require('mini.pairs').setup() end)
MiniDeps.later(function () require('mini.surround').setup() end)

MiniDeps.later(function () require('mini.align').setup() end)
MiniDeps.later(function () require('mini.splitjoin').setup() end)
MiniDeps.later(function () require('mini.comment').setup() end)
MiniDeps.later(function () require('mini.move').setup() end)

-- navigation
MiniDeps.later(function () require('mini.ai').setup() end)
MiniDeps.later(function () require('mini.bracketed').setup() end) -- []
MiniDeps.later(function () require('mini.jump').setup() end) -- f, t
MiniDeps.later(function () require('mini.jump2d').setup() end) -- ^m
MiniDeps.later(function () require('mini.operators').setup() end)
MiniDeps.later(function ()
  MiniDeps.add("MeanderingProgrammer/render-markdown.nvim")
  local RenderMarkdown = require('render-markdown')
  RenderMarkdown.setup()
  vim.keymap.set('n', '<Leader>orm', function ()
    RenderMarkdown.toggle()
  end, { noremap = true, silent = true, desc = "[OTHER][R]enderMarkdown" })
end)
