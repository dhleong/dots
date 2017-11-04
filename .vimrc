" This must be first, because it changes other options as side effect
set nocompatible

" `Source` command def {{{
function! SourceInitFileFunc(path)
    let path = resolve(expand('~/.vim/init/' . a:path))
    exec "source " . path
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
    \'/Users/dhleong/Documents/workspace/',
    \'/Users/dhleong/code/appengine/',
    \'/Users/dhleong/code/go/',
    \'/Users/dhleong/code/',
    \'/Users/dhleong/IdeaProjects/',
    \'/Users/dhleong/unity/'
\]

"
" unite configs
"

" we don't want results from these dirs (inserted below)
" let _dirs = substitute("bin,node_modules,build,proguard,out/cljs,app/js/p,app/components", ",", "\/\\\\|", "g") 
let _dirs = map([
            \ "node_modules", "build", "proguard", "out",
            \ "app/js/p", "app/components", "target", "builds",
            \ ], 'v:val . "\/**"')
let b:dirs = _dirs

" borrow ignore extensions from wildignore setting
let _wilds = substitute(&wildignore, "[~.*]", "", "g") " remove unneeded
let _wilds = substitute(_wilds, ",", "\\\\|", "g") " replace , with \|
" let _wilds = '\%(^\|/\)\.\.\?$\|\.\%([a-zA-Z_0-9]*\)/\|' . _dirs . '\~$\|\.\%(' . _wilds . '\)$' " borrowed from default
let _wilds = '\%(^\|/\)\.\.\?$\|\.\%([a-zA-Z_0-9]*\)/\|\.\%(' . _wilds . '\)$' " borrowed from default
call unite#custom#source('file_rec/async', 'ignore_pattern', _wilds)
call unite#custom#source('file_rec/async', 'ignore_globs', _dirs)
call unite#custom#source('grep', 'ignore_pattern', _wilds)
call unite#custom#source('grep', 'ignore_globs', _dirs)
call unite#custom#source('file_rec/async', 'matchers', 
    \ ['converter_tail', 'matcher_fuzzy'])
call unite#custom#source('file_rec/async', 'converters', 
    \ ['converter_file_directory'])
call unite#custom#source('file_rec/async', 'sorters', 
    \ ['sorter_rank'])

" use ag for rec/async
let g:unite_source_rec_async_command =
            \ ['ag', '--follow', '--nocolor', '--nogroup',
            \  '--hidden', '-g', '']

function! GrepWord(path)
    let path = a:path
    if path == ''
        let path = '.'
    endif
    exe 'Unite grep:' . path . ':-iR:' .
                \ expand('<cword>') . ' -auto-preview'
endfunction

" keymaps
function! MapCtrlP(path)
    " craziness to ensure pwd is always set correctly
    " when creating the Unite buffer; for some reason it
    " isn't set as expected when opening Unite after using
    " the projectopen func below...

    if &ft == "java" && exists("*intellivim#InProject") && intellivim#IsRunning()
        nnoremap <buffer> <silent> <c-p> :Locate<cr>
    else
        let suffix =  '<cr>:silent! lcd ' . a:path . '<cr>:startinsert<cr>'
        execute 'nnoremap <C-p> :Unite file_rec/async:' . a:path . suffix
        execute 'nnoremap <C-w><C-p> :Unite file_rec/async:' .
            \ a:path . ' -default-action=tabopen' . suffix
        execute 'nnoremap <C-s><C-p> :Unite file_rec/async:' . 
            \ a:path . ' -default-action=vsplit' . suffix
    endif

    execute 'nnoremap <silent> <leader>/ :Unite grep:' . a:path . ':-iR -auto-preview<cr>'
    " NB: this would have to be an <expr> mapping
    execute 'nnoremap <silent> <leader>* :call GrepWord("' . a:path . '")<cr>'
endfunction

" default map for C-p (we'll remap with project directory soon)
call MapCtrlP("")
nnoremap <leader>/ :Unite grep:.:-iR -auto-preview<cr>
let g:unite_enable_ignore_case = 1

"
" new projectopen action to cooperate with SetPathToProject thingy
"
let my_projectopen = {
\ 'is_selectable' : 0,
\ }
function! my_projectopen.func(candidates)
    let pathDir = a:candidates.action__path . '/'

    " set path, etc.
    exe 'set path=' . pathDir . '**'
    let g:ProjectPath = pathDir
    let g:ProjectGrepPath = g:ProjectPath . '*'
    call MapCtrlP(pathDir)

    execute 'Unite file_rec/async:' . pathDir . ' -start-insert'
    execute 'lcd `=pathDir`' 
endfunction
call unite#custom#action('directory', 'projectopen', my_projectopen)
unlet my_projectopen

" use \p to open a list of project dirs, from which we can rec/async a file
" It's disappointingly slow to open, but... oh well
let g:UniteProjects = join(map(copy(g:ProjectParentPaths), "'directory:' . v:val"))
call unite#custom#source('directory', 'matchers', 'matcher_fuzzy')
call unite#custom#source('directory', 'sorters', 'sorter_selecta')
execute 'nnoremap <silent> <leader>p :Unite ' . g:UniteProjects .
    \ ' -start-insert -sync -unique -hide-source-names ' .
    \ ' -default-action=projectopen<cr>'

execute 'nnoremap <silent> <leader>y :Unite ' . g:UniteProjects .
    \ ' -start-insert -sync -unique -hide-source-names ' .
    \ ' -default-action=lily<cr>'

" fancier way to search through file than /
call unite#custom#source('line', 'matchers', 'matcher_fuzzy')
nnoremap <silent> \  :<C-u>Unite -buffer-name=search
    \ line -start-insert<CR>

"
" My project path script
"
let g:ProjectPath = "./"
let g:ProjectGrepPath = "*"

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
            let g:ProjectPath = pathDir
            let g:ProjectGrepPath = g:ProjectPath . '*'
            call MapCtrlP(g:ProjectPath)
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
