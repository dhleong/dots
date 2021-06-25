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
