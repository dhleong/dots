
" if guard to protect against E127
if !exists("*CreateTypescriptTestFile")
    function! CreateTypescriptTestFile()
        let type = expand('%:e')
        let path = expand('%:p')
        let path = substitute(path, "." . type . "$", "-test." . type, "")
        let path = substitute(path, "/src/", "/test/", "")

        exe "edit " . path
        if !filereadable(path)
            if !isdirectory(expand("%:p:h"))
                call mkdir(expand("%:p:h"), "p")
            endif

            let buffer = ['import * as chai from "chai";',
                        \ '',
                        \ 'chai.should();']
            call append(0, buffer)
        endif
    endfunction
endif

function! s:TslintInfo()
    let line = line('.')
    let list = ale#engine#GetLoclist(bufnr('%'))
    for l in list
        if l['lnum'] == line
            echo "Opening..."
            silent exe "!open https://palantir.github.io/tslint/rules/" . l['code']
            return
        endif
    endfor

    echo "No lint info"
endfunction

nnoremap <buffer> <c-w>gd :call dhleong#GotoInNewTab("GoToDefinition")<cr>
nnoremap <buffer> gd :YcmCompleter GoToDefinition<cr>
nnoremap <buffer> gti :call <SID>TslintInfo()<cr>
nnoremap <buffer> K :YcmCompleter GetDoc<cr>
nnoremap <buffer> <leader>jr :call dhleong#refactor#Rename()<cr>
nnoremap <buffer> <leader>js :YcmCompleter GoToReferences<cr>

nnoremap <buffer> <leader>op :exe 'find package.json'<cr>
nnoremap <buffer> <leader>top :tabe \| exe 'find package.json'<cr>

" 'new test'
nnoremap <buffer> <leader>nt :call CreateTypescriptTestFile()<cr>
" 'open test'
nnoremap <buffer> <leader>ot :exe 'find ' . substitute(expand('%'),
            \ "." . expand('%:e') . "$", "-test." . expand('%:e'), "")<cr>

if expand('%') =~# '-test.ts$'
    augroup RunLatte
        autocmd!
        autocmd BufWritePost <buffer> :call latte#Run()
    augroup END
endif

if expand('%:e') ==# 'tsx'
    " two-space tabs in tsx files, since we're embedding html
    setlocal tabstop=2 shiftwidth=2
endif
