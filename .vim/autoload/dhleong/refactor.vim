
function! dhleong#refactor#Rename()
    " TODO place cursor where it was in the word
    let word = expand('<cword>')
    call feedkeys('q:iYcmCompleter RefactorRename ' . word . "\<esc>b", 'n')
endfunction
