" Lazy-loaded functions for navigating between files
"

let s:fzf_options = '--no-clear'
let s:popupTermPatch = 'patch-8.2.0286'

func! s:ensureTerminalInput(_)
    if mode() !=# 't'
        " still in normal mode for some reason
        call feedkeys('i')
    endif
endfunc

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
        echo 'Unexpected input: ' . a:line
    endif

    let [ file, line; _ ] = parts
    exec a:sink . ' ' . file
    exe 'norm! ' . line . 'G'
    norm! zz
endfunc

func! s:FZF(config)
    let wrapped = fzf#wrap(a:config)

    " Ensure we have some basic colors, if not otherwise specified
    " (see g:fzf_colors)
    if get(wrapped, 'options', '') !~# '--color'
        let wrapped.options .= ' --color=dark'
    endif

    return fzf#run(wrapped)
endfunc

func! dhleong#nav#FindGradle()
    try
        find! ./build.gradle
    catch
        find build.gradle
    endtry
endfunc

func! dhleong#nav#ByText(projectRoot, sink)
    " NOTE: use 4.. as the query and presentation target
    " to handle Swift (and other code that uses colons).
    " Use no-extended since we generally want strings of results
    " NOTE: nth=2.. instead of 4 is (I THINK) because with-nth
    " changes the indexing, so 4 becomes 2.
    let opts = s:fzf_options . ' '
            \ . '--with-nth=1,4.. '
            \ . '--nth=2.. '
            \ . '--delimiter=:'
    let window = 'aboveleft 15new'
    let source = 'rg --column --line-number --no-heading --smart-case'
                \." --glob '!*.lock'"
                \." --glob '!tsconfig.json'"
                \.' -- .'

    if has(s:popupTermPatch)
        " popup window!
        let window = { 'width': 1.0, 'height': 0.8 }
    endif

    call s:FZF(fzf#vim#with_preview({
        \ 'dir': a:projectRoot,
        \ 'options': opts,
        \ 'source': source,
        \ 'sink': function('s:OpenByText', [a:sink]),
        \ 'window': window,
        \ }, 'right:+{2}/2'))
endfunc

func! dhleong#nav#InProject(projectRoot, sink)
    let projectRoot = a:projectRoot
    if projectRoot =~# '^\s*$'
        let projectRoot = get(g:, 'otsukare_default_project_root', '')
    endif
    if projectRoot =~# '^\s*$'
        echo 'Not in a project directory'
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

    call s:FZF({
        \ 'dir': projectRoot,
        \ 'options': s:fzf_options,
        \ 'source': 'list-repo-files',
        \ 'sink': a:sink,
        \ 'window': window,
        \ })

    call timer_start(10, function('s:ensureTerminalInput'))
endfunc

func! dhleong#nav#InProjectSubpath(projectRoot, sink)
    " NOTE: projectRoot should always have a trailing backslash
    let contextPath = expand('%:p')
    if empty(contextPath)
        " in a new tab, for example
        let contextPath = expand('#:p')
    endif

    let path = contextPath[len(a:projectRoot) - 1:]
    let subpaths = split(path, '/')
    if !len(subpaths)
        return dhleong#nav#InProject(a:projectRoot, a:sink)
    endif

    let fullPath = a:projectRoot . subpaths[0]
    call dhleong#nav#InProject(fullPath, a:sink)
endfunc

func! dhleong#nav#Projects()
    let dirs = ''
    for parentPath in g:ProjectParentPaths
        if isdirectory(parentPath)
            let dirs = dirs . ' ' . parentPath . '*'
        endif
    endfor

    if !len(dirs)
        echom 'No project dirs exist? Checked:'
        echom g:ProjectParentPaths
        return
    endif

    let cmd = 'ls -d' . dirs
    call s:FZF({
        \ 'options': s:fzf_options,
        \ 'source': cmd,
        \ 'sink': function('s:OpenProject'),
        \ })
endfunc

func! dhleong#nav#Link()
    let url = expand('<cfile>')
    exe '!open ' . url
endfunc
