-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ======= Global behavior ================================

-- Unload buffers when all windows are abandoned
vim.o.hidden = false

-- ======= Indent-related ===================================

vim.o.autoindent = true
vim.o.copyindent = true -- copy the previous indentation on autoindenting

-- 4 space indents
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- ======= Search handling ==================================

vim.o.incsearch = true
vim.o.ignorecase = true -- ignore case in search....
vim.o.smartcase = true  -- but if we WANT case, use it

-- ======= Editing tweaks ===================================

if not vim.env.SSH_TTY then
  -- only set clipboard if not in ssh, to make sure the OSC 52
  -- integration works automatically. Requires Neovim >= 0.10.0
  vim.o.clipboard = "unnamedplus" -- Sync with system clipboard
end

-- vim.o.clipboard = 'unnamed'

-- -- NOTE: When not in tmux, we can just use the normal clipboard and
-- -- skip loading this completely
-- if vim.env.TMUX then
--   vim.g.clipboard = require 'dhleong.clipboard'.create()
-- end


-- ======= Visual tweaks ====================================

-- adjust splits behaviour
vim.o.splitright = true   -- horizontal splits should not open on the left...
vim.o.equalalways = false -- 'no equal always'--don't resize my splits!

-- show horrid tabs
vim.o.list = true
vim.o.listchars = 'tab:»·,trail:·'

-- ======= Undo management ==================================

-- Persist undo, but don't pollute the file system
local undodir = vim.env.HOME .. '/.local/share/nvim/.tmp/undo'
if not vim.fn.isdirectory(undodir) then
  -- Make the directory
  vim.fn.mkdir(undodir, 'p')
end
vim.o.undodir = undodir
vim.o.undofile = true


-- ======= Misc =============================================

if vim.fn.executable('/bin/zsh') ~= 0 then
  vim.go.shell = '/bin/zsh'
end

-- ======= temp ===========================================

vim.g['test#custom_runners'] = vim.tbl_extend('keep', vim.g['test#custom_runners'] or {}, {
  GDScript = {
    'GUT',
  },
})
