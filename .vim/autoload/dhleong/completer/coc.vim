let s:completer = {'_type': 'coc'}

func! dhleong#completer#coc#Create()
    return s:completer
endfunc

func! s:completer.FillLocList() abort
    call coc#rpc#request('fillDiagnostics', [bufnr('%')])
endfunc

func! s:completer.HasQuickFixes() abort
    let fixes = coc#rpc#request('quickfixes', [])
    return !empty(fixes)
endfunc

func! s:completer.PerformQuickFix() abort
    call CocActionAsync('doQuickfix')
endfunc

func! s:completer.RenameWord() abort
    call CocActionAsync('rename')
endfunc
