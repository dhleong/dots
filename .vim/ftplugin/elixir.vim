" ======= mappings ========================================

nnoremap <buffer> <c-w>gd :call dhleong#GotoInNewTab("GoToDefinition")<cr>
nnoremap <buffer> gd :YcmCompleter GoToDefinition<cr>
nnoremap <buffer> K :YcmCompleter GetHover<cr>
nnoremap <buffer> <leader>js :YcmCompleter GoToReferences<cr>
