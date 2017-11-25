
" ======= Better loclist/error navigation ==================

" all types that should fallback to standard loclist navigation
" and which rely on YCM's diagnostics instead of ALE
let s:YcmJumpingTypes = [
    \ 'cs', 'cpp',
    \ ]

function! FallbackJumpToNextError()
    try
        lnext
    catch /.*No.more.items$/
        lfirst
    catch /.*No.Errors$/
        echohl WarningMsg
        echo "No errors :)"
        echohl None
    catch /.*No.location.list$/
    endtry
endfunction

function! JumpToNextError()
    if index(s:YcmJumpingTypes, &ft) != -1
        " make sure diagnostics are up-to-date
        :YcmForceCompileAndDiagnostics 
        redraw!

        call FallbackJumpToNextError()
        return
    endif

    " imported from the source of ALENext so we
    "  can add some helpful messages
    let l:nearest = ale#loclist_jumping#FindNearest('after', 1)
    if !empty(l:nearest)
        call cursor(l:nearest)

        if l:nearest[0] == line('.')
            echo "This is the only error!"
        endif
    else
        echohl WarningMsg
        echo "No errors :)"
        echohl None
    endif
endfunction

nnoremap <silent> ]c :call JumpToNextError()<cr>

