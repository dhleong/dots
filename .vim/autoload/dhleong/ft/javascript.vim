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

    augroup RunLatte
        " ensure it exists
    augroup END

    augroup TryRunLatte
        " ensure it exists
    augroup END

    let testSuffix = '-test.' . expand('%:e') . '$'
    if expand('%') =~# testSuffix
        autocmd RunLatte BufWritePost <buffer> :call latte#Run()
    else
        autocmd TryRunLatte BufWritePost <buffer> :call latte#TryRun()
    endif


    " ======= Plugin config ===================================

    " use trailing commas when wrapping argument lines
    let b:argwrap_tail_comma = 1
endfunc
