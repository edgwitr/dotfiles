local MiniDeps = require('mini.deps')

-- selector
MiniDeps.later(function () require('mini.fuzzy').setup() end)
MiniDeps.later(function () require('mini.pick').setup() end)
MiniDeps.later(function () require('mini.extra').setup() end)
-- MiniDeps.later(function() require('mini.misc').setup() end)
