" Lazy-loaded functions for navigating between files
"

let s:fzf_options = '--color=dark --no-clear'

" " we don't want results from these dirs (inserted below)
" " let _dirs = substitute("bin,node_modules,build,proguard,out/cljs,app/js/p,app/components", ",", "\/\\\\|", "g") 
" let s:_dirs = map([
"             \ 'node_modules', 'build', 'proguard', 'out',
"             \ 'app/js/p', 'app/components', 'target', 'builds',
"             \ ], "v:val . '\/**'")
" let b:dirs = s:_dirs

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
    let opts = s:fzf_options . ' --with-nth=3 --delimiter=:'
    call fzf#run({
        \ 'dir': a:projectRoot,
        \ 'options': opts,
        \ 'source': 'ag --nobreak --noheading --ignore vendor .',
        \ 'sink': function('s:OpenByText', [a:sink]),
        \ 'window': 'aboveleft 15new',
        \ })
endfunc

func! dhleong#nav#InProject(projectRoot, sink)
    call fzf#run({
        \ 'dir': a:projectRoot,
        \ 'options': s:fzf_options,
        \ 'source': 'list-repo-files',
        \ 'sink': a:sink,
        \ 'window': 'aboveleft 15new',
        \ })
endfunc

func! dhleong#nav#Projects()
    let cmd = "ls -d"
    for parentPath in g:ProjectParentPaths
        if isdirectory(parentPath)
            let cmd = cmd . " " . parentPath . "*"
        endif
    endfor
    call fzf#run({
        \ 'options': s:fzf_options,
        \ 'source': cmd,
        \ 'sink': function('s:OpenProject'),
        \ })
endfunc
