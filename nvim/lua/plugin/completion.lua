local MiniDeps = require('mini.deps')

MiniDeps.later(function () require('mini.completion').setup() end)
MiniDeps.later(function () require('mini.snippets').setup() end)
