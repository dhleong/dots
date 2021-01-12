" Lazy-loaded functions for navigating between files
"

let s:fzf_options = '--color=dark --no-clear'
let s:popupTermPatch = "patch-8.2.0286"


func! s:OpenProject(dir)
    let pathDir = a:dir

    " set path, etc.
    exe 'set path=' . pathDir . '**'
    execute 'lcd `=pathDir`'
    call dhleong#projects#MapCtrlP(pathDir)

    call dhleong#nav#InProject(pathDir, 'e')
    execute 'lcd `=pathDir`'

    " NOTE: fzf vim plugin has a startinsert call at the end of its exec_term
    " routine that seems to get delayed and run around... now, probably thanks
    " to us calling fzf#run from within the "sink" callback. So we counteract
    " it with this stopinsert to avoid being unnecessarily in insert mode.
    stopinsert
endfunc

func! s:OpenByText(sink, line)
    let parts = split(a:line, ':')
    if len(parts) < 2
        echo "Unexpected input: " . a:line
    endif

    let [ file, line; _ ] = parts
    exec a:sink . ' ' . file
    exe 'norm! ' . line . 'G'
    norm! zz
endfunc

func! dhleong#nav#FindGradle()
    try
        find! ./build.gradle
    catch
        find build.gradle
    endtry
endfunc

func! dhleong#nav#ByText(projectRoot, sink)
    " NOTE: use 3.. as the query and presentation target
    " to handle Swift (and other code that uses colons).
    " Use no-extended since we generally want strings of results
    " NOTE: nth=2.. instead of 3 is (I THINK) because with-nth
    " changes the indexing, so 3 becomes 2.
    let opts = s:fzf_options . ' '
            \ . '--with-nth=1,3.. '
            \ . '--nth=2.. '
            \ . '--no-extended '
            \ . '--delimiter=:'
    let window = 'aboveleft 15new'

    if has(s:popupTermPatch)
        " popup window!
        let window = { 'width': 1.0, 'height': 0.8 }
    endif

    call fzf#run(fzf#vim#with_preview({
        \ 'dir': a:projectRoot,
        \ 'options': opts,
        \ 'source': 'ag --nobreak --noheading --ignore vendor .',
        \ 'sink': function('s:OpenByText', [a:sink]),
        \ 'window': window,
        \ }))
endfunc

func! dhleong#nav#InProject(projectRoot, sink)
    if a:projectRoot =~# '^\s*$'
        echo "Not in a project directory"
        return
    endif

    let window = 'aboveleft 15new'
    if has(s:popupTermPatch)
        " popup window!
        let window = {
            \ 'width': 0.4,
            \ 'height': 0.8,
            \ 'yoffset': 0.2,
            \ 'xoffset': 0.9,
            \ }
    endif

    call fzf#run({
        \ 'dir': a:projectRoot,
        \ 'options': s:fzf_options,
        \ 'source': 'list-repo-files',
        \ 'sink': a:sink,
        \ 'window': window,
        \ })
endfunc

func! dhleong#nav#Projects()
    let dirs = ""
    for parentPath in g:ProjectParentPaths
        if isdirectory(parentPath)
            let dirs = dirs . " " . parentPath . "*"
        endif
    endfor

    if !len(dirs)
        echom "No project dirs exist? Checked:"
        echom g:ProjectParentPaths
        return
    endif

    let cmd = "ls -d" . dirs
    call fzf#run({
        \ 'options': s:fzf_options,
        \ 'source': cmd,
        \ 'sink': function('s:OpenProject'),
        \ })
endfunc

func! dhleong#nav#Link()
    let url = expand("<cfile>")
    exe "!open " . url
endfunc
