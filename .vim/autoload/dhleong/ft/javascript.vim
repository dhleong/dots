func! s:CreateTestFilePath()
    let type = expand('%:e')
    let path = expand('%:p')
    let path = substitute(path, '.' . type . '$', '-test.' . type, '')
    let path = substitute(path, '/src/', '/test/', '')
    let path = substitute(path, '/lib/', '/test/', '')

    return path
endfunc

func! s:FillTestFile(path)
    let path = a:path
    if !filereadable(path)
        if !isdirectory(expand('%:p:h'))
            call mkdir(expand('%:p:h'), 'p')
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
            let buffer = []
        endif

        call append(0, buffer)
    endif
endfunc

" if guard to protect against E127
if !exists('*s:CreateJsLikeTestFile')
    function! s:CreateJsLikeTestFile()
        let path = s:CreateTestFilePath()

        exe 'edit ' . path
        call s:FillTestFile(path)
    endfunction
endif

func! s:FindPrettierConfig()
    let old = &wildignore
    set wildignore+=**/node_modules/**

    let path = trim(system('git rev-parse --show-toplevel'))
    let prettierFile = findfile('.prettierrc', path)

    let &wildignore = old
endfunc

func! dhleong#ft#javascript#Config()
    " Shared config for javascript-based languages (including typescript)

    " ======= settings ========================================

    if expand('%:e') =~# '[jt]sx'
        " two-space tabs in tsx files, since we're embedding html
        setlocal tabstop=2 shiftwidth=2
    endif

    " load from a prettier config, if it exists
    let prettierFile = s:FindPrettierConfig()
    if filereadable(prettierFile)
        " NOTE: findfile automatically also tries to search various suffixes,
        " including .js for js files, so we need to make sure to handle the
        " .prettierrc.js case
        let ts = -1
        if prettierFile =~# '.js$'
            let tsMatch = matchlist(readfile(prettierFile), '\vtabWidth[ ]*[:=][ ]*(\d+)')
            if len(tsMatch)
                let ts = str2nr(tsMatch[1])
            endif
        else
            try
                let config = json_decode(join(readfile(prettierFile)))
                let ts = get(config, 'tabWidth', 4)
            catch /.*/
                " ignore?
            endtry
        endif

        if ts > 0
            exe 'setlocal tabstop=' . ts . ' shiftwidth=' . ts
        endif

        " also, enable prettier auto-format
        let b:ale_fixers = {
            \ 'typescript': ['prettier'],
            \ 'javascript': ['prettier'],
            \ }
        let b:ale_fix_on_save = 1
    endif


    " ======= mappings ========================================

    call dhleong#completer().MapNavigation()
    call dhleong#completer().HandleConfirmCompletion(['.', '(', '<space>'])

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
