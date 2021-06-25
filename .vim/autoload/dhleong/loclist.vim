
" all types that should fallback to standard loclist navigation
" and which rely on YCM's diagnostics instead of ALE
let s:YcmJumpingTypes = [
    \ 'cs', 'cpp',
    \ ]

func! s:FallbackJumpToNextError()
    try
        lnext
    catch /.*No.more.items$/
        lfirst
    catch /.*No.Errors$/
        call dhleong#util#EchoBold('No errors :)')
    catch /.*No.location.list$/
    endtry
endfunc

func! s:JumpToMergeConflict()
    let line = search('=======')
    if line == 0
        normal! ]c
        call dhleong#util#EchoBold('No more merge conflicts in file')
    endif
endfunc

func! dhleong#loclist#JumpToNextError()
    if &diff
        " NOTE: this is a good idea, but rarely what I want
        " " use built-in method of jumping to the next diff
        " normal! ]c
        call s:JumpToMergeConflict()
        return
    endif

    " make sure diagnostics are up-to-date
    call dhleong#completer().FillLocList()

    if index(s:YcmJumpingTypes, &filetype) != -1
        call s:FallbackJumpToNextError()
        return
    endif

    " imported from the source of ALENext so we
    "  can add some helpful messages
    let l:nearest = ale#loclist_jumping#FindNearest('after', 1)
    if !empty(l:nearest)
        call cursor(l:nearest)

        if l:nearest[0] == line('.')
            echo 'This is the only error!'
        endif
    else
        call s:FallbackJumpToNextError()
    endif
endfunc
