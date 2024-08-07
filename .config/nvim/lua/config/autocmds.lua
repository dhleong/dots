-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- -- For some reason, the autochdir option causes wacky behavior
-- --  with netrw, with this repro:
-- --   - open a file
-- --   - :vsp
-- --   - go up a dir via - and vinegar until you can open another dir
-- --   - when you open another subdir, netrw will fill the whole tabpage,
-- --       and the original buffer's contents will be overwritten
-- vim.cmd([[
--   augroup AutoChdir
--     autocmd!
--     autocmd BufEnter * silent! lcd %:p:h
--   augroup END
-- ]])
