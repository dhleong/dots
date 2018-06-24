
" Auto compile on write
function! s:compileLess()
    let destDir = ''
    if expand('%:p:h:t') == 'less'
        if isdirectory('../resources/public/css')
            let destDir = '../resources/public/css/'
        endif
    else
        let destDir = './'
    endif

    if destDir == ''
        return
    endif

    let destName = expand('%:t:r') . '.css'
    let dest = destDir . destName

    " silent !lessc % %:t:r.css > /dev/null
    let output = systemlist('lessc ' . shellescape(expand('%')) . ' 2> /dev/null')
    if len(output) > 0
        call writefile(output, dest)
    endif
endfunction

augroup LessAutoCompile
    autocmd!
    autocmd BufWritePost <buffer> call <SID>compileLess()
augroup END
