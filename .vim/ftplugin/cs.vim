
" let g:ycm_enable_diagnostic_signs = 0
" let g:ycm_show_diagnostics_ui = 0

nnoremap <buffer> gd :YcmCompleter GoTo<cr>
nnoremap <buffer> K :YcmCompleter GetDoc<cr>
nnoremap <buffer> <a-cr> :YcmCompleter FixIt<cr>

" nnoremap <buffer> <leader>jr "0yiwq:iYcmCompleter RefactorRename <esc>"0p
