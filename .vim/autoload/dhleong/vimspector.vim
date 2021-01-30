func! s:ConfigureWatches()
    nmap <buffer> dd <del>
endfunc

func! dhleong#vimspector#Config()
    augroup MyVimspectorConfigs
        autocmd!
        autocmd BufEnter vimspector.Watches call <SID>ConfigureWatches()
    augroup END
endfunc
