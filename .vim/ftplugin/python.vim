nmap <silent> <F19> :!python %<cr>

" let c-n do the regular local search
inoremap <buffer> <c-n> <c-x><c-n>

" the default one doesn't cooperate with vim-jedi for some reason
inoremap <buffer> <expr><S-Tab> pumvisible()? "\<up>\<C-n>\<C-p>" : "\<c-d>"

nnoremap <buffer> <c-w>gd :call dhleong#GotoInNewTab("GoToDefinition")<cr>
nnoremap <buffer> gd :YcmCompleter GoToDefinition<cr>
nnoremap <buffer> K :YcmCompleter GetDoc<cr>
nnoremap <buffer> <leader>jr :call dhleong#refactor#Rename()<cr>
nnoremap <buffer> <leader>js :YcmCompleter GoToReferences<cr>

let b:latte_python_exe = 'python3'

augroup RunPyLatte
    autocmd!
    autocmd BufWritePost *.py call latte#TryRun()
    autocmd BufWritePost test_*.py :call latte#Run()
augroup END
