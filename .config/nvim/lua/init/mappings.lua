local map = require'helpers.map'

-- Laziness:
vim.cmd(':source ~/.vim/init/mappings.vim')

-- utils {{{
local function nnoremap(lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, {
      noremap = true,
      silent = true,
    })
end

local function tnoremap(lhs, rhs)
    vim.api.nvim_set_keymap('t', lhs, rhs, {
      noremap = true,
      silent = true,
    })
end

local function inoremap(lhs, rhs)
    vim.api.nvim_set_keymap('i', lhs, rhs, { noremap = true })
end
-- }}}

-- vim compat {{{
--

-- nvim makes Y consistent with C/D but I like the old way
nnoremap('Y', 'yy')

-- }}}

-- nvim config file opening:
--

-- helpers {{{
local paths = {
    nvim = function(path)
        return '~/.config/nvim/' .. path
    end,
}
paths.init = function(path)
    return paths.nvim('lua/init/' .. path)
end

local function mapOpenFile(leaderMap, path)
    local with_path = '<c-r>=resolve("' .. path .. '")<cr><cr>'
    nnoremap('<Leader>' .. leaderMap, ':e ' .. with_path)
    nnoremap('<Leader>t' .. leaderMap, ':tabe ' .. with_path)
end
-- }}}

mapOpenFile('ev', paths.nvim('init.lua'))
mapOpenFile('vm', paths.init('mappings.lua'))
mapOpenFile('vp', paths.init('plugins.lua'))
mapOpenFile('vs', paths.init('settings.lua'))
mapOpenFile('vb', paths.nvim('bundle'))

mapOpenFile('eft', paths.nvim('ftplugin/" . &filetype . ".lua'))

--
-- ======= Text manipulation ================================

-- Muscle memory from macOS defaults
inoremap('<m-bs>', '<c-w>')


-- ======= File navigation ==================================

nnoremap('<leader>p', "<cmd>lua require'dhleong.nav'.projects()<cr>")

-- NOTE: netrw's gx is not behaving for some reason. Let's just
-- use our own because netrw is weird
nnoremap('gx', "<cmd>lua require'dhleong.nav'.link()<cr>")

-- ======= Terminal =========================================

-- "Open terminal"
map.nno '<leader>ot' {
  lua_module = 'dhleong.term',
  lua_call = 'split()',
}

-- I'm used to <a-bs> and it sorta works but for whatever reason it leaves a . behind where <c-w>
-- doesn't, so let's just use that:
map.tno('<a-bs>', '<c-w>')

-- Saving files with <apple-s> in CLI mode (with help from iterm2)
-- Configure a key map to "Send text with 'vim' Special Chars" as <F-20>
nnoremap('<F-20>', ':w<cr>')
inoremap('<F-20>', '<esc>:w<cr>')

nnoremap('<F-21>', ':tabe<cr>')  -- Similarly, <apple-t> ...
inoremap('<F-21>', '<esc>:tabe<cr>')
nnoremap('<F-22>', ':q<cr>')  -- ... and <apple-w>
inoremap('<F-22>', '<esc>:q<cr>')

nnoremap('<F-23>', 'gt')
nnoremap('<F-24>', 'gT')
inoremap('<F-23>', '<esc>gt')
inoremap('<F-24>', '<esc>gT')
tnoremap('<F-23>', '<C-\\><C-N>gt')
tnoremap('<F-24>', '<C-\\><C-N>gT')
