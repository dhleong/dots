func! s:InvokeTest(bufnr) " {{{
    let rootDir = getbufvar(a:bufnr, 'dhleong_rootDir')
    let testCmd = getbufvar(a:bufnr, 'dhleong_testCmd')

    if testCmd =~# '\<rm\>' || testCmd =~# '\<sudo\>'
        " sanity check
        return
    endif

    call term_sendkeys(a:bufnr, 'cd ' . rootDir . "\<cr>")
    call term_sendkeys(a:bufnr, "clear\<cr>")
    call term_sendkeys(a:bufnr, testCmd . "\<cr>")
endfunc " }}}

func! dhleong#autorun#Try() " {{{
    for nr in range(1, winnr('$'))
        let bufnr = winbufnr(nr)
        if bufnr != -1 && getbufvar(bufnr, 'dhleong_testCmd', '') !=# ''
            call s:InvokeTest(bufnr)

            " done!
            return
        endif
    endfor
endfunc " }}}

func! dhleong#autorun#OpenTerm(config) " {{{
    let rootDir = get(a:config, 'rootDir', '')
    if rootDir ==# '' && has_key(a:config, 'rootFile')
        let root = findfile(a:config.rootFile, '.;')
        let rootDir = fnamemodify(root, ':h')
    else
        let rootDir = expand('%:p:h')
    endif

    let command = a:config.command
    let winSizePercent = get(a:config, 'winSize', 0.5)

    let mainBuf = bufnr('%')
    let winSize = floor(winSizePercent * winheight('$'))
    let path = expand('%:p')

    if get(a:config, 'relativePath', 0)
        let path = path[len(rootDir)+1:]
    endif

    let command = substitute(command, '%s', path, '')

    " manually split the window so we can open it how we want,
    "  and reuse the window via the curwin option
    exe 'below split | resize ' . string(winSize)
    let termBufNr = term_start(&shell, {
                \ 'curwin': 1,
                \ 'term_finish': 'close',
                \ })

    let b:dhleong_rootDir = rootDir
    let b:dhleong_testCmd = command

    call term_wait(termBufNr)
    call s:InvokeTest(termBufNr)

    let mainWin = bufwinnr(mainBuf)
    exe mainWin . 'winc w'
endfunc " }}}
