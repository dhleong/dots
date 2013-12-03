
" <Enter> follows link
nnoremap <buffer> <CR> <C-]>

" <BS> goes back to main topic
nnoremap <buffer> <BS> <C-T>

" o/O = next/previous topic
nnoremap <buffer> o /'\l\{2,\}'<CR>
nnoremap <buffer> O ?'\l\{2,\}'<CR>

" s/S = next/previous subject
nnoremap <buffer> s /\|\zs\S\+\ze\|<CR>
nnoremap <buffer> S ?\|\zs\S\+\ze\|<CR>

" q closes the buffer
nnoremap q :q<CR>
