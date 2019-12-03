func! s:CreateTestFilePath()
    let type = expand('%:e')
    let path = expand('%:p')
    let path = substitute(path, "." . type . "$", "-test." . type, "")
    let path = substitute(path, "/src/", "/test/", "")
    let path = substitute(path, "/lib/", "/test/", "")

    return path
endfunc

func! s:FillTestFile(path)
    let path = a:path
    if !filereadable(path)
        if !isdirectory(expand("%:p:h"))
            call mkdir(expand("%:p:h"), "p")
        endif

        let type = expand('%:e')
        if type =~# '^ts'
            let buffer = ['import * as chai from "chai";',
                        \ '',
                        \ 'chai.should();']
        elseif type =~# '^js'
            let buffer = ["const chai = require('chai');",
                        \ '',
                        \ 'chai.should();']
        else
            let buffer = [];
        endif

        call append(0, buffer)
    endif
endfunc

" if guard to protect against E127
if !exists("*s:CreateJsLikeTestFile")
    function! s:CreateJsLikeTestFile()
        let path = s:CreateTestFilePath()

        exe "edit " . path
        call s:FillTestFile(path)
    endfunction
endif

func! dhleong#ft#javascript#Config()
    " Shared config for javascript-based languages (including typescript)

    " ======= mappings ========================================

    nnoremap <buffer> <c-w>gd :call dhleong#GotoInNewTab("GoToDefinition")<cr>
    nnoremap <buffer> gd :YcmCompleter GoToDefinition<cr>
    nnoremap <buffer> K :YcmCompleter GetDoc<cr>
    nnoremap <buffer> <leader>jr :call dhleong#refactor#Rename()<cr>
    nnoremap <buffer> <leader>js :YcmCompleter GoToReferences<cr>

    nnoremap <buffer> <leader>op :exe 'find package.json'<cr>
    nnoremap <buffer> <leader>top :tabe \| exe 'find package.json'<cr>

    " 'new test'
    nnoremap <buffer> <leader>nt :call <SID>CreateJsLikeTestFile()<cr>

    " 'open test'
    nnoremap <buffer> <leader>ot :exe 'find ' . substitute(expand('%'),
                \ "." . expand('%:e') . "$", "-test." . expand('%:e'), "")<cr>

    " ======= testing =========================================

    let ext = '.' . expand('%:e')
    let testSuffix = '-test' . ext
    let testSuffix2 = '.test' . ext

    exe 'augroup RunLatte' . toupper(expand('%:e'))
        autocmd!
        exe 'autocmd BufWritePost *' . testSuffix . ' :call latte#Run()'
        exe 'autocmd BufWritePost *' . testSuffix2 . ' :call latte#Run()'
        exe 'autocmd BufWritePost *' . ext . ' :call latte#TryRun()'
    augroup END


    " ======= Plugin config ===================================

    " use trailing commas when wrapping argument lines
    let b:argwrap_tail_comma = 1
endfunc
