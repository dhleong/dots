
nnoremap <buffer> gd :YcmCompleter GoToDefinition<cr>
nnoremap <buffer> K :YcmCompleter GetDoc<cr>
nnoremap <buffer> <leader>jr :call dhleong#refactor#Rename()<cr>

nnoremap <buffer> gpd :!grunt deploy<cr>
nnoremap <buffer> gpi :!grunt lambda_invoke<cr>

nnoremap <buffer> <leader>op :exe 'find package.json'<cr>
nnoremap <buffer> <leader>top :tabe \| exe 'find package.json'<cr>

if expand('%') =~# '-test.js$'
    augroup RunLatte
        autocmd!
        autocmd BufWritePost <buffer> :call latte#Run()
    augroup END
endif

