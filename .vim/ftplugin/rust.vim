" ======= mappings ========================================

nnoremap <buffer> <c-w>gd :call dhleong#GotoInNewTab("GoToDefinition")<cr>
nnoremap <buffer> gd :YcmCompleter GoToDefinition<cr>
nnoremap <buffer> K :YcmCompleter GetDoc<cr>
nnoremap <buffer> <leader>jr :call dhleong#refactor#Rename()<cr>
nnoremap <buffer> <leader>js :YcmCompleter GoToReferences<cr>

" ======= Plugin config ===================================

" use trailing commas when wrapping argument lines
let b:argwrap_tail_comma = 1

let b:ale_fixers = {
    \ "rust": ["rustfmt"],
    \ }
let b:ale_fix_on_save = 1
