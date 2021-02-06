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


" ======= Test running ====================================

func! s:tryRunTests()
    let [line, _] = searchpos('\C#\[cfg(test)\]', 'nw', 0, 100)
    if line > 0
        call latte#Run()
    endif
endfunc


" ======= Debugging =======================================

call dhleong#vimspector#Config()

nnoremap <buffer> <silent> <leader>rd :call dhleong#ft#rust#debug#StartModTest()<cr>
nnoremap <silent> <leader>rq :call vimspector#Reset()<cr>

nnoremap <buffer> <silent> <leader>bc :call vimspector#ClearBreakpoints()<cr>
nnoremap <buffer> <silent> <leader>bt :call vimspector#ToggleBreakpoint()<cr>

nmap <buffer> <leader>dc <Plug>VimspectorRunToCursor
nmap <buffer> <leader>di <Plug>VimspectorStepInto
nmap <buffer> <leader>dn <Plug>VimspectorStepOver

" ======= Autocmds ========================================

augroup MyRustAutoCmds
    autocmd!

    autocmd BufWritePost *.rs call <SID>tryRunTests()
augroup END
