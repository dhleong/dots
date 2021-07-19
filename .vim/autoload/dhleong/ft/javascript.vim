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

    return prettierFile
endfunc

func! dhleong#ft#javascript#FindPrettierConfig()
    return s:FindPrettierConfig()
endfunc

func! dhleong#ft#javascript#ExtractPrettierConfig() " {{{
    let config = {}

    let prettierFile = s:FindPrettierConfig()
    if !filereadable(prettierFile)
        return config
    endif

    let config.found = 1

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
            let json = json_decode(join(readfile(prettierFile)))
            let ts = json(config, 'tabWidth', ts)
        catch /.*/
            " ignore?
        endtry
    endif

    if ts > 0
        let config.ts = ts
    endif

    return config
endfunc " }}}

func! dhleong#ft#javascript#Config()
    " Shared config for javascript-based languages (including typescript)

    " ======= settings ========================================

    if expand('%:e') =~# '[jt]sx'
        " two-space tabs in tsx files, since we're embedding html
        setlocal tabstop=2 shiftwidth=2
    endif

    " load from a prettier config, if it exists
    let config = dhleong#ft#javascript#ExtractPrettierConfig()
    if config.found
        if get(config, 'ts', 0) > 0
            exe 'setlocal tabstop=' . config.ts . ' shiftwidth=' . config.ts
        endif

        " also, enable prettier auto-format (without overriding other fixers)
        let languages = ['typescriptreact', 'typescript', 'javascript']
        let fixers = {}
        for language in languages
            let fixers[language] = get(g:ale_fixers, language, []) + ['prettier']
        endfor
        let b:ale_fixers = fixers
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
