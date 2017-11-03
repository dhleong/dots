
" let g:ycm_python_binary_path = '/Users/dhleong/tensorflow/bin/python3'

nmap <silent> <F19> :!python %<cr>

" let c-n do the regular local search
inoremap <buffer> <c-n> <c-x><c-n>

" the one above doesn't cooperate with vim-jedi for some reason
inoremap <buffer> <expr><S-Tab> pumvisible()? "\<up>\<C-n>\<C-p>" : "\<c-d>"

