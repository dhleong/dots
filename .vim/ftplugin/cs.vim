
" let g:ycm_enable_diagnostic_signs = 0
" let g:ycm_show_diagnostics_ui = 0

"
" Function defs
"

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

function! s:OpenProblems()
    let winnr = winnr()
    :YcmDiags

    if !len(getloclist(winnr))
        :q
        echo ""
        redraw!
        echohl WarningMsg
        echo "No problems! :)"
        echohl None
        return
    endif

    " automatically close the diags window when leaving it
    autocmd WinLeave <buffer> :q
endfunction

function! MyGetCSIndent(lnum) abort

    let this_line = getline(a:lnum)
    let previous_line = getline(a:lnum - 1)

    " Hit the start of the file, use zero indent.
    if a:lnum == 0
        return 0
    endif

    if previous_line =~? '^\s*\[[A-Za-z]' && previous_line =~? '\]$'
        " If previous_line is an attribute line:
        let ind = indent(a:lnum - 1)
        return ind
    elseif previous_line =~# '=>\s*$' && this_line =~# "{"
        return cindent(a:lnum - 1)
    else
        return cindent(a:lnum)
    endif

endfunction

"
" Settings
"

setlocal indentexpr=MyGetCSIndent(v:lnum)
let b:did_indent = 1

"
" Mappings
"
nnoremap <buffer> <c-w>gd :call <SID>GotoInNewTab()<cr>
nnoremap <buffer> gd :YcmCompleter GoTo<cr>
" 'goto initial definition'
nnoremap <buffer> gid :YcmCompleter GoToDefinition<cr>
nnoremap <buffer> K :YcmCompleter GetDoc<cr>
nnoremap <buffer> <a-cr> :YcmCompleter FixIt<cr>:cclose<cr>
nnoremap <buffer> <leader>ji :OmniSharpFixUsings<cr>
nnoremap <buffer> <leader>jr :OmniSharpRename<cr>
nnoremap <buffer> <leader>op :call <SID>OpenProblems()<cr>

nnoremap <buffer> <silent> <leader>pr :call <SID>RunProject()<cr>

"
" augroup
"
augroup omnisharp_commands
    autocmd!

    "show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
augroup END

" nnoremap <buffer> <leader>jr "0yiwq:iYcmCompleter RefactorRename <esc>"0p
