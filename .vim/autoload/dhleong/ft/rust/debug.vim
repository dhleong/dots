func! dhleong#ft#rust#debug#StartModTest()
    let path = expand('%:p:r')
    let root_end = stridx(path, '/src/')
    let mod = substitute(path[root_end + 5:], '/', '::', 'g')

    echom "Compiling " . mod . " ..."

    let path = ''
    let lines = systemlist('cargo test --no-run --message-format=json ' . mod)
    for i in range(len(lines) - 1, 0, -1)
        let line = lines[i]
        if empty(line) || line[0] != '{'
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
