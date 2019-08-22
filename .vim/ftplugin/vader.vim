nnoremap <buffer> <d-r> :Vader<cr>
call scriptease#setup_vim()

augroup RunLatte
    autocmd!
    autocmd BufWritePost *.vader :call latte#Run()
augroup END
