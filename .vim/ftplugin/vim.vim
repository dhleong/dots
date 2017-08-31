
" ======= Settings =========================================

setlocal foldmethod=marker


" ======= Mappings =========================================

function! GotoPluginHomepage()
    redraw!
    let line = getline('.')
    let matches = matchlist(line, 'Plug ''\(.*\)''')
    if len(matches) > 1
        let plugin = matches[1]
        if -1 != stridx(plugin, '/')
            " probably git
            if 0 != stridx(plugin, "file:")
                call system("open https://github.com/" . plugin)
            endif
        endif
    endif
endfunction

" goto plugin home/open
nnoremap <buffer> gph :call GotoPluginHomepage()<cr>
nnoremap <buffer> gpo :call GotoPluginHomepage()<cr>

" let K call vim 'help' when in a vim file
nnoremap <buffer> K :exe 'help ' .expand('<cword>')<cr>


" ======= Autocmds =========================================

" Source automatically on write
augroup VimAutoSource
    autocmd!
    autocmd BufWritePost .vimrc source %
    autocmd BufWritePost */.vim/init/*.vim source %
    autocmd BufWinEnter <buffer> normal zM
augroup END
