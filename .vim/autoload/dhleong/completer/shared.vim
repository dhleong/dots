func! dhleong#completer#shared#MapSharedNavigation(method)
    let method = empty(a:method) ? 'GoToDefinition' : a:method
    exe 'nnoremap <buffer> <c-w>gd :call dhleong#GotoInNewTab("' . method . '")<cr>'
    exe 'nnoremap <buffer> gd :call dhleong#completer().Navigate("' . method . '")<cr>'

    nnoremap <buffer> <leader>jr :call dhleong#refactor#Rename()<cr>
endfunc
