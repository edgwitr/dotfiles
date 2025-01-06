local MiniDeps = require('mini.deps')

MiniDeps.later(function () require('mini.git').setup() end)
MiniDeps.later(function ()
  require('mini.diff').setup({
    view = {
      style = 'sign',
      signs = { add = '+', change = '~', delete = '-' },
    },
  })
end)
