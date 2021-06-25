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

func! s:completer.Navigate(method) abort
    " Can we distinguish between GoTo and GoToDefinition?
    call CocActionAsync('jumpDefinition')
endfunc

func! s:completer.MapNavigation(...) abort
    call dhleong#completer#shared#MapSharedNavigation(get(a:, 1, ''))

    nnoremap <silent><buffer> K :call CocActionAsync('doHover')<cr>
    nmap <silent><buffer> <leader>js <Plug>(coc-references)
endfunc
