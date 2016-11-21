
" let g:ycm_enable_diagnostic_signs = 0
" let g:ycm_show_diagnostics_ui = 0

if !exists('*<sid>GotoInNewTab')
    function! s:GotoInNewTab() 
        let c = getpos('.')
        tabe %
        call cursor(c[1], c[2])
        :YcmCompleter GoTo
    endfunction
endif

function! s:RunProject()
    silent !osascript -e 'activate application "Unity"'
    silent !osascript -e 'tell application "System Events" to keystroke "p" using command down'
    echo "Project playing!"
endfunction

nnoremap <buffer> <c-w>gd :call <SID>GotoInNewTab()<cr>
nnoremap <buffer> gd :YcmCompleter GoTo<cr>
nnoremap <buffer> K :YcmCompleter GetDoc<cr>
nnoremap <buffer> <a-cr> :YcmCompleter FixIt<cr>
nnoremap <buffer> <leader>ji :OmniSharpFixUsings<cr>

nnoremap <buffer> <silent> <leader>pr :call <SID>RunProject()<cr>

augroup omnisharp_commands
    autocmd!

    "show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
augroup END

" nnoremap <buffer> <leader>jr "0yiwq:iYcmCompleter RefactorRename <esc>"0p
