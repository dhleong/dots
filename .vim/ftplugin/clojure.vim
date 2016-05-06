" nmap <d-r> :Require!<cr>cqq

function! DoReload()
    try
        silent :Require
        silent :ClojureHighlightReferences
    catch /Fireplace:.*REPL/
        redraw! | echohl Error | echo "No REPL found" | echohl None
    catch /nREPL/
        redraw! | echohl Error | echo "No REPL found" | echohl None
    endtry

endfunction

function! RunBufferTests()
    w
    redraw!
    let ns = fireplace#ns()
    if ns !~ '-test$'
        let ns = ns . "-test"
    endif
    silent :Require
    exe "RunTests " . ns

endfunction

function! GuessRoot()
    return fnamemodify(exists('b:java_root') ? b:java_root : fnamemodify(expand('%'), ':p:s?.*\zs[\/]src[\/].*??'), ':~')
endfunction

function! GuessPort()
    let path = GuessRoot() . "/.nrepl-port"
    if filereadable(expand(path))
        return system("cat " . path)
    else
        echo path
        return "7888"
    endif
endfunction

augroup ClojureGroup
    autocmd!
    autocmd BufWritePost *.clj call DoReload()
augroup END

" if guard to protect against E127
if !exists("*CreateTestFile")
    function! CreateTestFile()
        let path = expand('%:p')
        let path = substitute(path, ".clj$", "_test.clj", "")
        let path = substitute(path, "/src/", "/test/", "")

        let namespace = fireplace#ns()

        exe "edit " . path
        if !filereadable(path)
            if !isdirectory(expand("%:p:h"))
                call mkdir(expand("%:p:h"), "p")
            endif

            " was definitely new
            let buffer = ["(ns " . namespace . "-test",
                        \ "  (:require [clojure.test :refer :all]",
                        \ "            [" . namespace . " :refer :all]))",
                        \ "",
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

        let lastNs = substitute(expand('%:p:t'), ".clj", "", "")
        let path = expand('%:p:h') . "/" . newNs . ".clj"

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
        endif

    endfunction
endif

" options
" continue comments with 'enter'
setlocal formatoptions+=r

" add some custom fireplace maps...
nnoremap <buffer> <d-r> :%Eval<cr>
nnoremap <buffer> cpr :call RunBufferTests()<cr>
nnoremap <buffer> cpt :call RunBufferTests()<cr>
nmap <buffer> cql cqp<up><cr>
" ie: 'up'; just open last input but don't execute
exe 'nmap <buffer> cqu cqp<up>' &cedit | norm 0

" paste AFTER the current form, on the same level
" we use gpp instead of gp to prevent confusion with gpr
nnoremap <buffer> gpp %a<cr><esc>p%

" 'go stack open'
nnoremap <buffer> gso :lopen<cr>

" 'new test'
nnoremap <buffer> <leader>nt :call CreateTestFile()<cr>
" 'new file'
nnoremap <buffer> <leader>nf :call CreateNamespaceFile("tabe")<cr>
nnoremap <buffer> <leader>ot :exe 'find ' . substitute(expand('%'), ".clj$", "_test.clj", "")<cr>
nnoremap <buffer> <leader>op :exe 'find project.clj'<cr>

" ... disable default fireplace maps
let g:fireplace_no_maps = 1

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
nnoremap <buffer> glr :py restart_repl()<cr>
" stop
nnoremap <buffer> gls :call LeinReplCloseFunc()<cr>
" connect (ala :ConnectRepl)
nnoremap <buffer> glc :ConnectRepl<cr>

"
" Auto-start lein repl
"

python << EOF
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
        print "Error"
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

function! LeinReplConnectFunc()
    exe "Connect nrepl://localhost:" . GuessPort()
    " if "cljs" == expand("%:e")
    "     " call fireplace#platform().connection.eval("(figwheel-sidecar.repl-api/cljs-repl)")
    "     " exe "Piggieback (do (require 'figwheel-sidecar.repl-api) (figwheel-sidecar.repl-api/cljs-repl))"
    "     exe "Piggieback 9001"
    "     echo "Connected via Piggieback"
    " endif
endfunction

command! LeinRepl py open_repl()
command! ConnectRepl call LeinReplConnectFunc()

function! LeinReplCloseFunc()
    py close_all_repl()
endfunction
command! LeinReplClose call LeinReplCloseFunc()

command! LeinReplRestart py restart_repl()

augroup LeinShutDownGroup
    autocmd VimLeavePre * call LeinReplCloseFunc()
augroup END
