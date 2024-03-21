-- Space as mapleader is the most comfortable and easiest
-- to hit for me. We set it here so plugin-specific mappings
-- will use it as expected
vim.g.mapleader = " "

-- Using the same as the "local leader" for now
vim.g.maplocalleader = " "

local safe_require = require('helpers.init').safe_require

safe_require 'init.plugins'

safe_require 'init.commands'
safe_require 'init.settings'
safe_require 'init.mappings'
safe_require 'init.lsp'
safe_require 'init.github'
safe_require 'init.statusline'
safe_require 'init.treesitter'

require 'dhleong.projects'.init()
