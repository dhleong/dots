
if !exists('*s:switchToSourceFolder')
    function! s:switchToSourceFolder(name)
        let targetFolderName = a:name
        if targetFolderName == '%'
            let serviceName = expand('%:r')
            let targetFolderName = serviceName
        endif

        let path = targetFolderName . '/' . expand('%')
        exe 'find ' . path
    endfunction
endif

" don't show tabs because golang just loves them :\
setlocal listchars=tab:\ \ ,trail:·

" auto-continue comments on <cr>
setlocal formatoptions+=r

nnoremap <buffer> gd :YcmCompleter GoTo<cr>
nnoremap <buffer> <c-w>gd :call dhleong#GotoInNewTab('', ':YcmCompleter GoTo')<cr>
nnoremap <buffer> <leader>pb :GoBuild<cr>

nnoremap <buffer> <leader>ji :GoImports<cr>
nnoremap <buffer> <leader>jr :GoRename<cr>
nnoremap <buffer> <leader>js :GoReferrers<cr>

" 'switch to interface'
nnoremap <buffer> <leader>si :call <SID>switchToSourceFolder('%')<cr>
nnoremap <buffer> <leader>sv :call <SID>switchToSourceFolder('service')<cr>
nnoremap <buffer> <leader>sp :call <SID>switchToSourceFolder('api')<cr>

if expand('%') =~# '_test.go$'
    augroup RunLatte
        autocmd!
        autocmd BufWritePost <buffer> :call latte#Run()
    augroup END
endif

