let s:completer = {'_type': 'feather'}

func! dhleong#completer#feather#Create()
    return s:completer
endfunc

func! s:completer.FillLocList() abort
    " TODO
endfunc

func! s:completer.HasQuickFixes() abort
    " TODO
    return 0
endfunc

func! s:completer.PerformQuickFix() abort
    " TODO
endfunc

func! s:completer.RenameWord() abort
    " TODO
endfunc

func! s:completer.Navigate(method) abort
    " TODO
endfunc

func! s:completer.MapNavigation(...) abort
    " call dhleong#completer#shared#MapSharedNavigation(get(a:, 1, ''))
    "
    " nnoremap <silent><buffer> K :call CocActionAsync('doHover')<cr>
    " nmap <silent><buffer> <leader>js <Plug>(coc-references)
    " TODO
endfunc

func! s:completer.HandleConfirmCompletion(keys) abort
    " NOP: We don't do anything with this... yet
endfunc
