" This must be first, because it changes other options as side effect
set nocompatible

" `Source` command def {{{
function! SourceInitFileFunc(path)
    let l:path = resolve(expand('~/.vim/init/' . a:path))
    exec 'source ' . l:path
endfunction
command! -nargs=1 Source :call SourceInitFileFunc(<args>)
" }}}

" space as mapleader is the most comfortable and easiest
" to hit for me. We set it here so plugin-specific mappings
" will use it as expected
let mapleader = " "

" source the plug defs and settings
Source 'plugins.vim'

" now, source settings, maps, etc.
Source 'abbr.vim'
Source 'settings.vim'
Source 'commands.vim'
Source 'mappings.vim'

Source 'github.vim'
Source 'loclist.vim'
Source 'terminal.vim'

" disorganized stuff:

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
\]

function! MapCtrlP(path)
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
function! SetPathToProject()
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
            call MapCtrlP(pathDir)
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

    " the vimrc has a special path to access the init files
    if expand("%") == ".vimrc"
        let inits = resolve(expand("~/.vim/init"))
        exec "set path=" . inits . "/**," . &path
    endif

    " reset ctrl-p to default
    call MapCtrlP("")
endfunction

augroup PathToProjectCmds
    " have some nice auto paths
    autocmd!
    autocmd BufEnter * call SetPathToProject()
augroup END
