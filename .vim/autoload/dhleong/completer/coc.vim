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

func! s:completer.MapNavigation() abort
    " FIXME: new tab handling
    nnoremap <buffer> <c-w>gd :call dhleong#GotoInNewTab("GoToDefinition")<cr>
    nmap <silent><buffer> gd <Plug>(coc-definition)
    nmap <silent><buffer> <leader>js <Plug>(coc-references)
    nnoremap <buffer> <leader>jr :call dhleong#refactor#Rename()<cr>
    nnoremap <silent><buffer> K :call CocActionAsync('doHover')<cr>
endfunc
