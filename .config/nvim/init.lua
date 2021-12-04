-- Space as mapleader is the most comfortable and easiest
-- to hit for me. We set it here so plugin-specific mappings
-- will use it as expected
vim.g.mapleader = " "

-- Using the same as the "local leader" for now
vim.g.maplocalleader = " "

require 'init.plugins'

require 'init.settings'
require 'init.mappings'
require 'init.lsp'
