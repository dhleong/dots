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
