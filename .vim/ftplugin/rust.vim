" ======= mappings ========================================

call dhleong#completer().MapNavigation()

" ======= Plugin config ===================================

" use trailing commas when wrapping argument lines
let b:argwrap_tail_comma = 1

let b:ale_fixers = {
    \ 'rust': ['rustfmt'],
    \ }
let b:ale_fix_on_save = 1


" ======= Test running ====================================

func! s:tryRunTests()
    " prefer to re-run a failed test, if any
    if latte#TryRun({'ifFailed': 1})
        return
    endif

    let [line, _] = searchpos('\C#\[cfg(test)\]', 'nw', 0, 100)
    if line > 0
        call latte#Run()
        return
    endif

    " no tests and n on failed? just try to re-run any
    call latte#TryRun()
endfunc


" ======= Debugging =======================================

call dhleong#vimspector#Config()

command! Debug call dhleong#ft#rust#debug#StartApp()

nnoremap <buffer> <silent> <leader>rd :call dhleong#ft#rust#debug#StartModTest()<cr>
nnoremap <silent> <leader>rq :call vimspector#Reset()<cr>

nnoremap <buffer> <silent> <leader>bc :call vimspector#ClearBreakpoints()<cr>
nnoremap <buffer> <silent> <leader>bt :call vimspector#ToggleBreakpoint()<cr>

" ======= Autocmds ========================================

augroup MyRustAutoCmds
    autocmd!

    autocmd BufWritePost *.rs call <SID>tryRunTests()
augroup END
