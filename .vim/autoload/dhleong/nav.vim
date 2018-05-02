" Lazy-loaded functions for navigating between files
"

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
    call MapCtrlP(pathDir)

    call dhleong#nav#InProject(pathDir, 'e')
    execute 'lcd `=pathDir`'
endfunc

func! dhleong#nav#InProject(projectRoot, sink)
    " TODO: it might be nice to update list-repo-files to not necessarily rely
    "  on git ls-tree. It's certainly fast, but it does miss out on files that
    "  haven't been added to the repo yet.
    call fzf#run({
        \ 'dir': a:projectRoot,
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
        \ 'source': cmd,
        \ 'sink': function('s:OpenProject'),
        \ })
endfunc
