func! s:GetTestNameUnderCursor()
    let cursor = getcurpos()
    let testLine = search('#[test\]\n.*fn \(\i\+\)', 'b')
    if testLine == 0
        return ''
    endif

    let match = matchlist(getline(testLine + 1), '\(\s*\)\(pub \)\?fn \(\i\+\)')
    let lastIndent = len(match[1])
    let name = match[3]

    while 1
        let parentMod = search('\s*\(pub \)\?mod \i\+ ', 'b')
        if parentMod == 0
            echom 'no parent'
            break
        endif

        let match = matchlist(getline(parentMod), '\(\s*\)\(pub \)\?mod \(\i\+\)')

        let indent = len(match[1])
        if indent < lastIndent
            let name = match[3] . '::' . name
            let lastIndent = indent
        endif

        if indent == 0
            break
        endif
    endwhile

    call cursor(cursor[1:])
    return name
endfunc

func! dhleong#ft#rust#debug#StartModTest()
    let path = expand('%:p:r')
    if path =~# '/mod'
        let path = fnamemodify(path, ':h')
    endif

    let rootEnd = stridx(path, '/src/')
    let mod = substitute(path[rootEnd + 5:], '/', '::', 'g')

    let testName = s:GetTestNameUnderCursor()
    if testName !=# ''
        let mod .= '::' . testName
    endif

    echom 'Compiling ' . mod . ' ...'

    let path = ''
    let lines = systemlist('cargo test --no-run --message-format=json ' . mod)
    for i in range(len(lines) - 1, 0, -1)
        let line = lines[i]
        if empty(line) || line[0] !=# '{'
            continue
        endif

        let data = json_decode(line)
        if get(data, 'reason', '') ==# 'compiler-artifact'
            let path = data['executable']
            break
        endif
    endfor

    if path ==# ''
        echom 'No executable produced'
        return
    endif

    redraw!

    call vimspector#LaunchWithSettings({
        \ 'configuration': 'Run Test',
        \ 'Exe': path,
        \ 'Module': mod,
        \ })
endfunc

func! dhleong#ft#rust#debug#StartApp()
    echom 'Compiling  ...'

    let path = ''
    !cargo build
    redraw!

    call vimspector#LaunchWithSettings({
        \ 'configuration': 'Run App',
        \ })
endfunc
