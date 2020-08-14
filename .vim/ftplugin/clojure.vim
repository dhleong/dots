
" ======= utils ===========================================

function! s:pprint_recall() abort
    let platform = 'clojure'
    if "cljs" == expand("%:e")
        let ns = 'cljs'
    endif

    " NOTE: if we just eval directly, shadow may simply echo it in the console
    " instead of returning it (this could also just be due to an old version
    " of shadow...)
    " call fireplace#eval('(' . ns . '.pprint/pp)')
    let resp = fireplace#platform().Eval('(symbol (with-out-str (' . ns . '.pprint/pp)))')
    echo join(resp.value, "\n")
endfunction


" ======= Options, etc ====================================

" continue comments with 'enter'
setlocal formatoptions+=r

"
" hearth configs
"

let g:hearth_ignored_build_ids = [':ci']
let g:hearth_ignored_build_regex = ':ci.*'

"
" vim-clojure-static configs
"

let g:clojure_align_multiline_strings = 1


let s:fuzzy_indent_spade = [ '^at-media' ]
let s:fuzzy_indent_specter = [
    \ '^recursive-path',
    \ '^if-path',
    \ ]

let g:clojure_fuzzy_indent_patterns = [
    \ '^with', '^def', '^let', '^plet', '^go-loop', '^fn-', '^when-',
    \ ]
    \ + s:fuzzy_indent_spade
    \ + s:fuzzy_indent_specter

" ======= Custom maps =====================================

" 're-load'
nnoremap <buffer> grl :Require<cr>

" execute the 'last' quasi-repl command
nmap <buffer> cql cqp<up><cr>

" ie: 'up'; just open last input but don't execute
exe 'nmap <buffer> cqu cqp<up>' &cedit | norm 0

" 'nice print recall'
nnoremap <silent> <buffer> cnpr :<C-U>call <SID>pprint_recall()<CR>

" re-evaluate the current defn
nmap <buffer> cpf cpaF

" paste AFTER the current form, on the same level
" we use gpp instead of gp to prevent confusion with gpr
nnoremap <buffer> gpp %a<cr><esc>p%

"
" Project file navigation
"

nnoremap <buffer> <leader>op :exe 'find project.clj'<cr>
nnoremap <buffer> <leader>top :tabe \| exe 'find project.clj'<cr>

nnoremap <buffer> <leader>os :exe 'find shadow-cljs.edn'<cr>
nnoremap <buffer> <leader>tos :tabe \| exe 'find shadow-cljs.edn'<cr>


"
" REPL management
" NOTE: I mostly just open a repl externally these days...

" (re)start
nnoremap <buffer> glr :call hearth#repl#internal#Restart()<cr>
" stop
nnoremap <buffer> gls :call hearth#repl#internal#CloseAll()<cr>


"
" Fireplace will normally overwrite our maps, so we create them
" after it's done activating
"

func! s:overwriteMaps()
    nnoremap <buffer> cpr :call hearth#test#RunForBuffer()<cr>
    nmap <buffer> gd <Plug>FireplaceDjump
    nmap <buffer> <C-W>gd <Plug>FireplaceDtabjump
endfunc

augroup dhleongClojure
    au!
    au User FireplaceActivate call s:overwriteMaps()
augroup END
