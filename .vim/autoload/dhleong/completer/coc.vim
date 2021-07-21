let s:completer = {'_type': 'coc'}

func! dhleong#completer#coc#Create()
    return s:completer
endfunc

func! s:completer.FillLocList() abort
    call coc#rpc#request('fillDiagnostics', [bufnr('%')])
endfunc

func! s:completer.HasQuickFixes() abort
    return CocHasProvider('codeAction')
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

func! s:ConfirmCompletion(key) abort
    let state = complete_info()
    let selected = state['selected']
    if selected == -1
        return a:key
    endif

    " NOTE: this does not actually seem to do anything:
    let item = state['items'][selected]
    call coc#rpc#notify('CocAutocmd', ['CompleteDone', item])

    return a:key
endfunc

func! s:completer.HandleConfirmCompletion(keys) abort
    for key in a:keys
        exe 'inoremap <buffer><silent><expr> ' . key . ' <SID>ConfirmCompletion("' . key . '")'
    endfor
endfunc
