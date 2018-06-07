
" array of paths pointing to parent directories
"   of project directories; IE: each path here
"   contains subdirectories which themselves are
"   project directories.
" NOTE that we're lazy, so these MUST contain
"   the trailing backslash
let g:ProjectParentPaths = [
    \'/Users/dhleong/git/',
    \'/Users/dhleong/code/appengine/',
    \'/Users/dhleong/code/go/src/github.com/interspace/',
    \'/Users/dhleong/code/go/src/github.com/dhleong/',
    \'/Users/dhleong/code/',
    \'/Users/dhleong/.dotfiles/',
\]

function! dhleong#projects#MapCtrlP(path)
    " craziness to ensure pwd is always set correctly
    " when creating the Unite buffer; for some reason it
    " isn't set as expected when opening Unite after using
    " the projectopen func below...

    if &ft == "java" && exists("*intellivim#InProject") && intellivim#IsRunning()
        nnoremap <buffer> <silent> <c-p> :Locate<cr>
    else
        execute 'nnoremap <silent> <buffer> <c-p> :call ' .
                    \ 'dhleong#nav#InProject("' a:path .'", "e")<cr>'
        execute 'nnoremap <silent> <buffer> <c-w><c-p> :call ' .
                    \ 'dhleong#nav#InProject("' a:path .'", "tabe")<cr>'
        execute 'nnoremap <silent> <buffer> <c-s><c-p> :call ' .
                    \ 'dhleong#nav#InProject("' a:path .'", "vsplit")<cr>'

        exe 'nnoremap <silent> <buffer> \ :call ' .
                    \ 'dhleong#nav#ByText("' a:path . '", "e")<cr>'
    endif

    " " NB: this would have to be an <expr> mapping
    " execute 'nnoremap <silent> <leader>* :call GrepWord("' . a:path . '")<cr>'
endfunction

"
" My project path script
"

" function to automatically set the appropriate path :)
function! dhleong#projects#SetPathToProject()
    let this_file = expand("%:p:h") . '/' . expand("%:t")
    for projDir in g:ProjectParentPaths
        " check if our file matches a project src dir
        let len = strlen(projDir)
        if strpart(this_file, 0, len) == projDir
            let noDir = strpart(this_file, len) " path w/o projDir
            let idx = stridx(noDir, '/')

            " if there's no /, we're not in a project
            if idx == -1
                continue
            endif

            " build the path
            let projName = strpart(noDir, 0, idx+1)
            let pathDir = projDir . projName 

            " set it
            exe 'set path=' . pathDir . '**'
            call dhleong#projects#MapCtrlP(pathDir)

            if expand("%") == ".vimrc"
                let inits = resolve(expand("~/.vim/init"))
                exec "set path=" . inits . "/**," . &path
            endif
            return
        endif
    endfor

    " if we get here, we found no path
    if exists('g:DefaultPath')
        exe 'set path='.g:DefaultPath
    else
        " vim default path
        set path=.,/usr/include,,
    endif

    " reset ctrl-p to default
    call dhleong#projects#MapCtrlP("")
endfunction
