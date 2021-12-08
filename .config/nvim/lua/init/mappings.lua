-- Laziness:
vim.cmd(':source ~/.vim/init/mappings.vim')

-- utils {{{
local function nnoremap(lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true })
end
-- }}}

-- vim compat
--

-- nvim makes Y consistent with C/D but I like the old way
nnoremap('Y', 'yy')

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
    with_path = '<c-r>=resolve("' .. path .. '")<cr><cr>'
    nnoremap('<Leader>' .. leaderMap, ':e ' .. with_path)
    nnoremap('<Leader>t' .. leaderMap, ':tabe ' .. with_path)
end
-- }}}

mapOpenFile('ev', paths.nvim('init.lua'))
mapOpenFile('vp', paths.init('plugins.lua'))
mapOpenFile('vs', paths.init('settings.lua'))
mapOpenFile('vb', paths.nvim('bundle'))

mapOpenFile('eft', paths.nvim('ftplugin/" . &filetype . ".lua'))
