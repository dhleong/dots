
" ======= Better loclist/error navigation ==================

" all types that should fallback to standard loclist navigation
" and which rely on YCM's diagnostics instead of ALE
let s:YcmJumpingTypes = [
    \ 'cs', 'cpp',
    \ ]

function! s:FallbackJumpToNextError()
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

function! s:JumpToNextError()
    " make sure diagnostics are up-to-date
    :YcmForceCompileAndDiagnostics
    redraw!

    if index(s:YcmJumpingTypes, &ft) != -1
        call s:FallbackJumpToNextError()
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
    elseif len(getloclist(0)) > 0
        call s:FallbackJumpToNextError()
    else
        echohl WarningMsg
        echo "No errors :)"
        echohl None
    endif
endfunction

nnoremap <silent> ]c :call <SID>JumpToNextError()<cr>

