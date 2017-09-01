
" ======= Fix Line Endings =================================
" I haven't had a need for this in a while, but nice to keep around

function! FixLineEndingsFunc()
    update	 " Save any changes.
    e ++ff=dos	 " Edit file again, using dos file format 
    setlocal ff=unix	" This buffer will use LF-only line endings 
    w
endfunction
command! FixLineEndings call FixLineEndingsFunc()


" ======= Pretty-format JSON ===============================

function! DocToJson()
    :%!python -mjson.tool
    set ft=javascript
endfunction
command! JSON call DocToJson()


" ======= Open a split term to execute this file ===========
" Depends on `pip install when-changed` and, of course, Vim8

let &shell = '/bin/bash -l'
function! WatchAndRunFunc()
    try
        let progs = { 'javascript': 'node',
                    \ 'python': 'python'
                    \ }
        let prog = progs[&ft]
        let file = expand('%')
        execute 'terminal when-changed -1sv ' . file . ' ' . prog . ' ' . file
    catch
        echo "No program known for " . &ft
    endtry
endfunction
command! WatchAndRun call WatchAndRunFunc()


" ======= Open Terminal in the current file's dir ==========

function! OpenTermFunc()
    silent exe "!osascript -e 'tell app \"Terminal\" to do script \"cd '" 
                   \ .  expand('%:p:h') . "' && clear\"'"
    silent !osascript -e 'tell app "Terminal" to activate'
endfunction
command! Term call OpenTermFunc()

