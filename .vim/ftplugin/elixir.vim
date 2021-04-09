" ======= config ==========================================

let b:ale_linters = {
    \ 'elixir': ['credo', 'dialyxer', 'mix'],
    \ }

let b:ale_fixers = {
    \ 'elixir': ['mix_format'],
    \ }
let b:ale_fix_on_save = 1


" ======= mappings ========================================

nnoremap <buffer> <c-w>gd :call dhleong#GotoInNewTab("GoToDefinition")<cr>
nnoremap <buffer> gd :YcmCompleter GoToDefinition<cr>
nnoremap <buffer> K :YcmCompleter GetHover<cr>
nnoremap <buffer> <leader>js :YcmCompleter GoToReferences<cr>
