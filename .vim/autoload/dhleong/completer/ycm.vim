let s:completer = {'_type': 'ycm'}

func! dhleong#completer#ycm#Create()
    return s:completer
endfunc

func! s:completer.FillLocList()
    :YcmForceCompileAndDiagnostics
    redraw!
endfunc

func! s:completer.HasQuickFixes() abort
    let ycmCommands = youcompleteme#SubCommandsComplete('','', 0)
    return match(ycmCommands, 'FixIt')
endfunc

func! s:completer.PerformQuickFix() abort
    :YcmCompleter FixIt
endfunc

func! s:completer.RenameWord() abort
    " TODO place cursor where it was in the word
    let word = expand('<cword>')
    call feedkeys('q:iYcmCompleter RefactorRename ' . word . "\<esc>b", 'n')
endfunc

func! s:completer.MapNavigation() abort
    nnoremap <buffer> <c-w>gd :call dhleong#GotoInNewTab("GoToDefinition")<cr>
    nnoremap <buffer> gd :YcmCompleter GoToDefinition<cr>
    nnoremap <buffer> K :YcmCompleter GetDoc<cr>
    nnoremap <buffer> <leader>jr :call dhleong#refactor#Rename()<cr>
    nnoremap <buffer> <leader>js :YcmCompleter GoToReferences<cr>
endfunc
