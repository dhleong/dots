" ======= Settings =========================================

setlocal foldmethod=marker

" ======= Autocmds =========================================

func s:SourceIfLoaded()
    let allScriptNames = execute('scriptnames', 'silent!')
    let myPath = expand('%:p')
    execute "lua require'dhleong.dev'.reset_cache('" . myPath . "')"
    for line in split(allScriptNames, '\n')
        let [ id, path ] = split(line, ': ')
        if expand(path) ==# myPath
            source %
            return
        endif
    endfor
endfunc

augroup NvimLuaConfigHelpers
    autocmd!

    " Source automatically on write
    autocmd BufWritePost *.lua call s:SourceIfLoaded()

    " Collapse folds on enter
    autocmd BufWinEnter *.lua normal zM
augroup END

