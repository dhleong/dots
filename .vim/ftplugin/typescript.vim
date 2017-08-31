
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

nnoremap gd :YcmCompleter GoToDefinition<cr>
nnoremap K :YcmCompleter GetDoc<cr>

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

