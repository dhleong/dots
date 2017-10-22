" Lazy-loaded functions for use in various .vimrc mappings, etc.
"

function! dhleong#GotoInNewTab(...)
    let method = "GoTo"
    if a:0
        let method = a:1
    endif

    let c = getpos('.')
    tabe %
    call cursor(c[1], c[2])
    exe ':YcmCompleter ' . method
endfunction

function! dhleong#OpenPlugRepo()
    let regex = 'Plug ''\(.\{-\}\)'''
    let line = getline('.')
    let column = col('.')
    let start = 0
    while 1
        let matchIdx = match(line, regex, start)
        if matchIdx == -1
            return 0
        endif

        let matches = matchlist(line, regex, matchIdx)
        if !len(matches)
            break
        endif

        let start = start + matchIdx + len(matches[0])
        if column <= start
            let repo = matches[1]
            echo "Opening " . repo . "..."
            exe "silent !open https://github.com/" . repo
            return 1
        endif
    endwhile

    return 0
endfunction
