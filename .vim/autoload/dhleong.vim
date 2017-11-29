" Lazy-loaded functions for use in various .vimrc mappings, etc.
"

function! dhleong#GotoInNewTab(...)
    let l:method = 'GoTo'
    if a:0
        let l:method = a:1
    endif

    if a:0 > 1
        let l:cmd = a:2
    else
        let l:cmd = ':YcmCompleter ' . l:method
    endif

    let l:c = getpos('.')
    tabe %
    call cursor(l:c[1], l:c[2])
    exe l:cmd
endfunction

function! dhleong#OpenPlugRepo()
    let l:regex = 'Plug ''\(.\{-\}\)'''
    let l:line = getline('.')
    let l:column = col('.')
    let l:start = 0
    while 1
        let l:matchIdx = match(l:line, l:regex, l:start)
        if l:matchIdx == -1
            return 0
        endif

        let l:matches = matchlist(l:line, l:regex, l:matchIdx)
        if !len(l:matches)
            break
        endif

        let l:start = l:start + l:matchIdx + len(l:matches[0])
        if l:column <= l:start
            let l:repo = l:matches[1]
            echo 'Opening ' . l:repo . '...'
            exe 'silent !open https://github.com/' . l:repo
            return 1
        endif
    endwhile

    return 0
endfunction
