nnoremap <buffer> <d-r> :Vader<cr>

augroup RunLatte
    autocmd!
    autocmd BufWritePost *.vader :call latte#Run()
augroup END
