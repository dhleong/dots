
nnoremap gd :YcmCompleter GoToDefinition<cr>
nnoremap K :YcmCompleter GetDoc<cr>

nnoremap <buffer> <leader>op :exe 'find package.json'<cr>
nnoremap <buffer> <leader>top :tabe \| exe 'find package.json'<cr>

nnoremap <buffer> <leader>ot :exe 'find ' . substitute(expand('%'), 
            \ "." . expand('%:e') . "$", "-test." . expand('%:e'), "")<cr>

if expand('%') =~# '-test.ts$'
    augroup RunLatte
        autocmd!
        autocmd BufWritePost <buffer> :call latte#Run()
    augroup END
endif


