nnoremap <buffer> <d-r> :Vader<cr>

augroup RunLatte
    autocmd!
    autocmd BufWritePost <buffer> :call latte#Run()
augroup END
