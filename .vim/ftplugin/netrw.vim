
let s:dirPairs = [
    \ ["main", "test"]
\]

function! netrw#getCurrentSourceDir()

    let cwd = expand("%:p:h")
    let match = matchlist(cwd, 'src/\([^/]*\)/')
    if len(match) >= 2
        return match[1]
    else
        return ""
    endif

endfunction

function! netrw#openOtherSourceDir(name)
    let curSourceDir = netrw#getCurrentSourceDir()
    if curSourceDir == ""
        return
    endif

    let cwd = expand("%:p:h")
    let newSourceDir = substitute(cwd, "/" . curSourceDir . "/", "/" . a:name . "/", '')
    if newSourceDir != cwd
        exe 'e ' . newSourceDir
    else
        echo "You're already in " . a:name . "!"
    endif
endfunction

function! netrw#swapSourceDir()
    let curSourceDir = netrw#getCurrentSourceDir()
    if curSourceDir == ""
        return
    endif

    for pair in s:dirPairs
        if pair[0] == curSourceDir
            call netrw#openOtherSourceDir(pair[1])
        elseif pair[1] == curSourceDir
            call netrw#openOtherSourceDir(pair[0])
        endif
    endfor
endfunction

nnoremap <buffer> <leader>om :call netrw#openOtherSourceDir("main")<cr>
nnoremap <buffer> <leader>ot :call netrw#openOtherSourceDir("test")<cr>
nnoremap <buffer> <leader>oo :call netrw#swapSourceDir()<cr>
nnoremap <buffer> <leader>os :call netrw#swapSourceDir()<cr>
