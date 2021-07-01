nmap <silent> <F19> :!python %<cr>

" let c-n do the regular local search
inoremap <buffer> <c-n> <c-x><c-n>

" the default one doesn't cooperate with vim-jedi for some reason
inoremap <buffer> <expr><S-Tab> pumvisible()? "\<up>\<C-n>\<C-p>" : "\<c-d>"

call dhleong#completer().MapNavigation()

let b:latte_python_exe = 'python3'

augroup RunPyLatte
    autocmd!
    autocmd BufWritePost *.py call latte#TryRun()
    autocmd BufWritePost test_*.py :call latte#Run()
augroup END
