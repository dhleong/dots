
" ======= utils ===========================================

function! s:pprint_recall() abort
    let ns = 'clojure'
    if "cljs" == expand("%:e")
        let ns = 'cljs'
    endif
    call fireplace#eval('(' . ns . '.pprint/pp)')
endfunction


" ======= Options, etc ====================================

" continue comments with 'enter'
setlocal formatoptions+=r

"
" hearth configs
"

let g:hearth_tpl_author = "Daniel Leong"

"
" vim-clojure-static configs
"

let g:clojure_align_multiline_strings = 1
let g:clojure_fuzzy_indent_patterns = [
    \ '^with', '^def', '^let', '^go-loop', '^fn-', '^when-'
    \ ]

" ======= Custom maps =====================================

nnoremap <buffer> grl :Require<cr>
nnoremap <buffer> cpr :call hearth#test#RunForBuffer()<cr>
nnoremap <buffer> cpt :call hearth#test#RunForBuffer()<cr>
nmap <buffer> cql cqp<up><cr>
" ie: 'up'; just open last input but don't execute
exe 'nmap <buffer> cqu cqp<up>' &cedit | norm 0

" paste AFTER the current form, on the same level
" we use gpp instead of gp to prevent confusion with gpr
nnoremap <buffer> gpp %a<cr><esc>p%

" 'go stack open'
nnoremap <buffer> gso :lopen<cr>

" 'new file'
nnoremap <buffer> <leader>nf :call hearth#nav#create#Prompt("e")<cr>
" 'tab new file'
nnoremap <buffer> <leader>tf :call hearth#nav#create#Prompt("tabe")<cr>
" 'split new file'
nnoremap <buffer> <leader>snf :call hearth#nav#create#Prompt("vsplit")<cr>

" 'new test'
nnoremap <buffer> <leader>nt :call hearth#nav#create#Test()<cr>
nnoremap <buffer> <leader>ot :call hearth#nav#find#Test()<cr>
nnoremap <buffer> <leader>op :exe 'find project.clj'<cr>
nnoremap <buffer> <leader>top :tabe \| exe 'find project.clj'<cr>

nnoremap <buffer> <leader>os :exe 'find shadow-cljs.edn'<cr>
nnoremap <buffer> <leader>tos :tabe \| exe 'find shadow-cljs.edn'<cr>

" (re)start
nnoremap <buffer> glr :call hearth#repl#internal#Restart()<cr>
" stop
nnoremap <buffer> gls :call hearth#repl#internal#CloseAll()<cr>
" connect to a running repl
nnoremap <buffer> glc :call hearth#repl#Connect()<cr>

" ... disable default fireplace maps
let g:fireplace_no_maps = 1

" ... add some custom ones
nmap <buffer> cnpr :<C-U>call <SID>pprint_recall()<CR>

" ... and restore the original ones we use (there're a lot)
" NOTE: if fireplace would just not overwrite our mappings,
" we wouldn't have to do this.... Can we use an after mapping?


" ======= default fireplace maps ========================== {{{

nmap <buffer> cp <Plug>FireplacePrint
nmap <buffer> cpp <Plug>FireplaceCountPrint
nmap <buffer> cq <Plug>FireplaceEdit
nmap <buffer> cqq <Plug>FireplaceCountEdit
nmap <buffer> cqp <Plug>FireplacePrompt
exe 'nmap <buffer> cqc <Plug>FireplacePrompt' . &cedit . 'i'
map! <buffer> <C-R>( <Plug>FireplaceRecall

nmap <buffer> cm <Plug>FireplaceMacroExpand
nmap <buffer> cmm <Plug>FireplaceCountMacroExpand
nmap <buffer> c1m <Plug>Fireplace1MacroExpand
nmap <buffer> c1mm <Plug>FireplaceCount1MacroExpand

nmap <buffer> [<C-D>     <Plug>FireplaceDjump
nmap <buffer> ]<C-D>     <Plug>FireplaceDjump
nmap <buffer> <C-W><C-D> <Plug>FireplaceDsplit
nmap <buffer> <C-W>d     <Plug>FireplaceDsplit
nmap <buffer> <C-W>gd    <Plug>FireplaceDtabjump
nmap <buffer> gd    <Plug>FireplaceDjump

cmap <buffer> <C-R><C-F> <Plug><cfile>
cmap <buffer> <C-R><C-P> <Plug><cpath>
nmap <buffer> gf         <Plug>FireplaceEditFile
nmap <buffer> <C-W>f     <Plug>FireplaceSplitFile
nmap <buffer> <C-W><C-F> <Plug>FireplaceSplitFile
nmap <buffer> <C-W>gf    <Plug>FireplaceTabeditFile

nmap <buffer> K <Plug>FireplaceK
nmap <buffer> [d <Plug>FireplaceSource
nmap <buffer> ]d <Plug>FireplaceSource

" }}}
