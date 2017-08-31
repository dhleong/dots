
" Auto compile on write
function! CompileLess()
    if expand('%:p:h:t') == 'less'
        silent !lessc % ../resources/public/css/%:t:r.css > /dev/null
    else
        silent !lessc % %:t:r.css > /dev/null
    endif
endfunction

autocmd BufWritePost <buffer> call CompileLess()
