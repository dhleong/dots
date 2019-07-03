" nmap <d-r> :Require!<cr>cqq

" borrowed from vim-clojure-highlight
function! s:SessionExists()
    return exists('g:fireplace_nrepl_sessions') && len(g:fireplace_nrepl_sessions)
endfunction

function! s:DoReload()
    if !s:SessionExists()
        return
    endif
    try
        silent :Require
    catch /Fireplace:.*REPL/
        redraw! | echohl Error | echo "No REPL found" | echohl None
    catch /nREPL/
        redraw! | echohl Error | echo "No REPL found" | echohl None
    endtry
endfunction

function! s:RunCljsTests(ns)
    let ns = a:ns
    let testExpr = "(cljs.test/run-tests '" . ns . ")"
    let expr = "(do " .
                \ "(cljs.core/require '" . ns . " :reload)" .
                \ testExpr . ")"
    let resp = fireplace#client().eval(
        \ expr,
        \ {'ns': ns},
        \ )

    if has_key(resp, 'out')
        if stridx(resp.out, 'FAIL') == -1 && stridx(resp.out, 'ERROR') == -1
            " TODO can we put this into the qflist?
            echo testExpr
        else
            echo resp.out
        endif
        return
    endif

    " something terrible happened;
    " upgrading cider/piggieback fixed this for me
    echo "Error: No `out` response"
    echo resp
endfunction

function! s:RunBufferTests()
    w
    redraw!
    let ns = fireplace#ns()
    if ns !~ '-test$'
        let ns = ns . "-test"
    endif

    silent :Require
    if expand('%:e') == 'cljs'
        call s:RunCljsTests(ns)
    else
        exe "RunTests " . ns
    endif

endfunction

function! s:DetectShadowJs()
    if expand('%:t') == 'shadow-cljs.edn'
        return 1
    endif

    if filereadable(expand(s:GuessRoot() . "/shadow-cljs.edn"))
        return 1
    endif

    return 0
endfunction

function! s:GuessRoot()
    if expand('%:t') == 'project.clj' || expand('%:t') == 'shadow-cljs.edn'
        return expand('%:p:h')
    endif
    return fnamemodify(exists('b:java_root') ? b:java_root : fnamemodify(expand('%'), ':p:s?.*\zs[\/]\(src\|test\)[\/].*??'), ':~')
endfunction

function! s:GuessPort()
    let l:root = s:GuessRoot()
    let l:path = l:root . "/.nrepl-port"
    if filereadable(expand(l:path))
        return system("cat " . l:path)
    endif

    if expand('%:e') == 'cljs'
        " for clojurescript sources, we might be trying to connect
        "  to a figwheel port
        let l:path = l:root . "/project.clj"
        if filereadable(expand(l:path))
            let l:raw = system("cat " . l:path . " | ag :nrepl-port")
            if len(l:raw)
                let l:match = matchlist(l:raw, '.\{-}:nrepl-port \([0-9]\+\)')
                if len(l:match) > 1
                    return l:match[1]
                endif
            endif
        endif
    endif

    " last ditch
    return "7888"
endfunction

augroup ClojureGroup
    autocmd!
    autocmd BufWritePost *.clj,*.cljc call <SID>DoReload()
augroup END

" if guard to protect against E127
if !exists("*s:FindTestFile")
    function! s:FindTestFile()
        let ext = expand('%:e')
        let fileName = substitute(
            \ expand('%'),
            \ '.' . ext . '$',
            \ '_test.' . ext,
            \ '')

        let dir = expand('%:p:h:t')

        exe 'find ' . dir . '/' . fileName
    endfunction
endif

" if guard to protect against E127
if !exists("*CreateTestFile")
    function! CreateTestFile()
        let type = expand('%:e')
        let path = expand('%:p')
        let path = substitute(path, "." . type . "$", "_test." . type, "")
        let path = substitute(path, "/src/", "/test/", "")

        let namespace = fireplace#ns()

        exe "edit " . path
        if !filereadable(path)
            if !isdirectory(expand("%:p:h"))
                call mkdir(expand("%:p:h"), "p")
            endif


            let import = []
            if type == 'cljs'
                let import = ["  (:require [cljs.test :refer-macros [deftest testing is]]",
                            \ "            [cljs.nodejs :as node]",
                            \ "            [" . namespace . " :refer []]))"]
            else

                let import = ["  (:require [clojure.test :refer :all]",
                            \ "            [" . namespace . " :refer :all]))"]
            endif

            " was definitely new
            let buffer = ["(ns " . namespace . "-test"] +
                        \ import +
                        \["",
                        \ "(deftest a-test",
                        \ "  (testing \"FIXME new test\"",
                        \ "    (is (= 0 1))))"]
            call append(0, buffer)
        endif

    endfunction
endif

" if guard to protect against E127
if !exists("*CreateNamespaceFile")
    function! CreateNamespaceFile(method)
        let method = a:method
        let newNs = input("New NS: ")
        if newNs == ""
            echo "Canceled"
            return
        endif

        let type = expand('%:e')
        let lastNs = substitute(expand('%:p:t'), '.' . type, '', 'g')
        let lastNs = substitute(lastNs, '_', '-', 'g')
        let newNsPath = substitute(newNs, '-', '_', 'g')
        let newNsPath = substitute(newNsPath, '\.', '/', 'g')
        let path = expand('%:p:h') . "/" . newNsPath . "." . type

        let namespace = fireplace#ns()
        let namespace = substitute(namespace, lastNs, newNs, "")

        exe method . " " . path
        if !filereadable(path)
            if !isdirectory(expand("%:p:h"))
                call mkdir(expand("%:p:h"), "p")
            endif

            " was definitely new
            let buffer = ["(ns ^{:author \"Daniel Leong\"",
                        \ "      :doc \"" . newNs . "\"}", 
                        \ "  " . namespace . ")",
                        \ ""]
            call append(0, buffer)
            call cursor(2, 12) " prepare to update the :doc
        endif

    endfunction
endif

" imported from fireplace
function! s:opfunc(type) abort
  let sel_save = &selection
  let cb_save = &clipboard
  let reg_save = @@
  try
    set selection=inclusive clipboard-=unnamed clipboard-=unnamedplus
    if type(a:type) == type(0)
      let open = '[[{(]'
      let close = '[]})]'
      if getline('.')[col('.')-1] =~# close
        let [line1, col1] = searchpairpos(open, '', close, 'bn', g:fireplace#skip)
        let [line2, col2] = [line('.'), col('.')]
      else
        let [line1, col1] = searchpairpos(open, '', close, 'bcn', g:fireplace#skip)
        let [line2, col2] = searchpairpos(open, '', close, 'n', g:fireplace#skip)
      endif
      while col1 > 1 && getline(line1)[col1-2] =~# '[#''`~@]'
        let col1 -= 1
      endwhile
      call setpos("'[", [0, line1, col1, 0])
      call setpos("']", [0, line2, col2, 0])
      silent exe "normal! `[v`]y"
    elseif a:type =~# '^.$'
      silent exe "normal! `<" . a:type . "`>y"
    elseif a:type ==# 'line'
      silent exe "normal! '[V']y"
    elseif a:type ==# 'block'
      silent exe "normal! `[\<C-V>`]y"
    elseif a:type ==# 'outer'
      call searchpair('(','',')', 'Wbcr', g:fireplace#skip)
      silent exe "normal! vaby"
    else
      silent exe "normal! `[v`]y"
    endif
    redraw
    if fireplace#client().user_ns() ==# 'user'
      return repeat("\n", line("'<")-1) . repeat(" ", col("'<")-1) . @@
    else
      return @@
    endif
  finally
    let @@ = reg_save
    let &selection = sel_save
    let &clipboard = cb_save
  endtry
endfunction

function! s:pprintop(type) abort
    let todo = s:opfunc(a:type)
    let ns = 'clojure'
    if "cljs" == expand("%:e")
        let ns = 'cljs'
    endif
    call fireplace#eval('(' . ns . '.pprint/pprint ' . todo . ')')
endfunction

function! s:pprint_recall() abort
    let ns = 'clojure'
    if "cljs" == expand("%:e")
        let ns = 'cljs'
    endif
    call fireplace#eval('(' . ns . '.pprint/pp)')
endfunction


" options
" continue comments with 'enter'
setlocal formatoptions+=r

" add some custom fireplace maps...
nnoremap <buffer> grl :Require<cr>
nnoremap <buffer> cpr :call <SID>RunBufferTests()<cr>
nnoremap <buffer> cpt :call <SID>RunBufferTests()<cr>
nmap <buffer> cql cqp<up><cr>
" ie: 'up'; just open last input but don't execute
exe 'nmap <buffer> cqu cqp<up>' &cedit | norm 0

" paste AFTER the current form, on the same level
" we use gpp instead of gp to prevent confusion with gpr
nnoremap <buffer> gpp %a<cr><esc>p%

" 'go stack open'
nnoremap <buffer> gso :lopen<cr>

" 'new file'
nnoremap <buffer> <leader>nf :call CreateNamespaceFile("e")<cr>
" 'tab new file'
nnoremap <buffer> <leader>tf :call CreateNamespaceFile("tabe")<cr>
" 'split new file'
nnoremap <buffer> <leader>snf :call CreateNamespaceFile("vsplit")<cr>

" 'new test'
nnoremap <buffer> <leader>nt :call CreateTestFile()<cr>
nnoremap <buffer> <leader>ot :call <SID>FindTestFile()<cr>
nnoremap <buffer> <leader>op :exe 'find project.clj'<cr>
nnoremap <buffer> <leader>top :tabe \| exe 'find project.clj'<cr>

nnoremap <buffer> <leader>os :exe 'find shadow-cljs.edn'<cr>
nnoremap <buffer> <leader>tos :tabe \| exe 'find shadow-cljs.edn'<cr>

" ... disable default fireplace maps
let g:fireplace_no_maps = 1

" ... add some custom ones
nmap <buffer> cnp :<C-U>set opfunc=<SID>pprintop<CR>g@
nmap <buffer> cnpr :<C-U>call <SID>pprint_recall()<CR>
nmap <buffer> cnpp :<C-U>call <SID>pprintop(v:count)<CR>

" ... and restore the original ones we use (there're a lot)
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
if empty(mapcheck('gf', 'n'))
nmap <buffer> gf         <Plug>FireplaceEditFile
endif
if empty(mapcheck('<C-W>f', 'n'))
nmap <buffer> <C-W>f     <Plug>FireplaceSplitFile
endif
if empty(mapcheck('<C-W><C-F>', 'n'))
nmap <buffer> <C-W><C-F> <Plug>FireplaceSplitFile
endif
if empty(mapcheck('<C-W>gf', 'n'))
nmap <buffer> <C-W>gf    <Plug>FireplaceTabeditFile
endif

if empty(mapcheck('K', 'n'))
nmap <buffer> K <Plug>FireplaceK
endif
nmap <buffer> [d <Plug>FireplaceSource
nmap <buffer> ]d <Plug>FireplaceSource


"
" lein repl commands!
"

" (re)start
nnoremap <buffer> glr :pyx restart_repl()<cr>
" stop
nnoremap <buffer> gls :call LeinReplCloseFunc()<cr>
" connect (ala :ConnectRepl)
nnoremap <buffer> glc :ConnectRepl<cr>

"
" Auto-start lein repl
"

pyx << EOF
import os, platform, subprocess, vim

try:
    # only define once, please
    clj_repl_procs
except:
    clj_repl_procs = []

def open_repl():
    win = platform.system() == "Windows"
    env = None
    if platform.system() == "Darwin":
        env = os.environ.copy()
        env["PATH"] += ":/usr/local/bin"

    dir = os.path.dirname(vim.current.buffer.name)
    proc = subprocess.Popen(['lein', 'repl'],
                          env=env, cwd=dir,
                          stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                          stderr=subprocess.STDOUT, shell=win)

    clj_repl_procs.append(proc)

    line = proc.stdout.readline()
    if not line:
        print("Error")
    else:
        # re-open the file to auto-connect
        # do like this to suppress the "return to continue"
        # and make it look fancy
        vim.command('e | redraw | echohl IncSearch | echo "Repl Started" | echohl None')


def close_all_repl():
    for proc in clj_repl_procs:
        proc.stdin.close()
        proc.kill()

def restart_repl():
    vim.command('redraw | echo "Closing Repl..."')
    close_all_repl()
    vim.command('redraw | echo "Restaring Repl..."')
    open_repl()

EOF

function! LeinReplConnectFunc(...)
    let l:port = a:0 ? a:1 : s:GuessPort()
    let l:root = s:GuessRoot()
    exe "Connect " . l:port . " " . l:root
    if "cljs" == expand("%:e")
        if s:DetectShadowJs()
            " TODO pick build?
            :Piggieback :lib
        else
            exe "Piggieback (figwheel-sidecar.repl-api/repl-env)"
        endif
    endif
endfunction

command! LeinRepl pyx open_repl()
command! -nargs=? ConnectRepl call LeinReplConnectFunc(<args>)

function! LeinReplCloseFunc()
    pyx close_all_repl()
endfunction
command! LeinReplClose call LeinReplCloseFunc()

command! LeinReplRestart pyx restart_repl()

augroup LeinShutDownGroup
    autocmd!
    autocmd VimLeavePre * call LeinReplCloseFunc()
augroup END

"
" vim-clojure-static configs
"

let g:clojure_align_multiline_strings = 1
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let', '^go-loop', '^fn-', '^when-']
