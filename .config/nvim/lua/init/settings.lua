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
vim.o.smartcase = true -- but if we WANT case, use it

-- ======= Editing tweaks ===================================

vim.o.clipboard = 'unnamed'

-- ======= Visual tweaks ====================================

-- color scheme
vim.cmd('colorscheme spring-night')
vim.g.airline_theme = "spring_night"
vim.o.termguicolors = true

-- adjust splits behaviour
vim.o.splitright = true -- horizontal splits should not open on the left...
vim.o.equalalways = false -- 'no equal always'--don't resize my splits!

-- show horrid tabs
vim.o.list = true
vim.o.listchars = 'tab:»·,trail:·'

-- ======= Misc =============================================

--
-- for some reason, the autochdir option causes wacky behavior
--  with netrw, with this repro:
--   - open a file
--   - :vsp
--   - go up a dir via - and vinegar until you can open another dir
--   - when you open another subdir, netrw will fill the whole tabpage,
--       and the original buffer's contents will be overwritten
vim.cmd([[
  augroup AutoChdir
    autocmd!
    autocmd BufEnter * silent! lcd %:p:h
  augroup END
]])
