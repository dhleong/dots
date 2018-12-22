
" ======= Settings =========================================

setlocal foldmethod=marker


" ======= Mappings =========================================

function! s:gotoPluginHomepage()
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
nnoremap <buffer> gph :call <SID>gotoPluginHomepage()<cr>
nnoremap <buffer> gpo :call <SID>gotoPluginHomepage()<cr>

" let K call vim 'help' when in a vim file
nnoremap <buffer> K :exe 'help ' .expand('<cword>')<cr>

nnoremap <buffer> <silent> gd :call dhleong#nav#vim#GoToDefinition()<cr>

" ======= Autocmds =========================================

augroup VimAutoSource
    autocmd!

    " Source automatically on write
    autocmd BufWritePost .vimrc source %
    autocmd BufWritePost */.vim/init/*.vim source %

    " Collapse folds on enter
    autocmd BufWinEnter <buffer> normal zM

    " Disable ale linting in vimrc (it's more annoying than helpful)
    autocmd BufWinEnter .vimrc let b:ale_enabled = 0
    autocmd BufWinEnter */.vim/**.vim let b:ale_enabled = 0
augroup END
