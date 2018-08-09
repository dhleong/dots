
function! dhleong#refactor#Rename()
    " TODO can we be more awesome?
    " whitespace at the end is intentional!
    call feedkeys(':YcmCompleter RefactorRename ', 'n')
endfunction
