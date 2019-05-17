nnoremap <silent> <cr> :call SendLineToR("stay")<cr>
nnoremap <silent> K :call RAction("help")<cr>
nnoremap <silent> cpiw :exe ':call SendCmdToR("' . expand('<cword>') . '")'<cr>
