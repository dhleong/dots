" This must be first, because it changes other options as side effect
set nocompatible

" `Source` command def {{{
function! SourceInitFileFunc(path)
    let path = resolve(expand('~/.vim/init/' . a:path))
    exec "source " . path
endfunction
command! -nargs=1 Source :call SourceInitFileFunc(<args>)
" }}}

" source the plug defs and settings
Source 'plugins.vim'

" ======= Global settings ==================================

Source 'abbr.vim'
Source 'settings.vim'
Source 'mappings.vim'

Source 'github.vim'
Source 'loclist.vim'

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

" TODO replace with :term
" " While we're here, how about a vim shell? :)
" let g:ConqueTerm_CloseOnEnd = 1 " close the tab/split when the shell exits
" let g:ConqueTerm_StartMessages = 0 " shhh. it's fine
" nmap <silent> <leader>vs :ConqueTermVSplit bash -l<cr>
" nmap <silent> <leader>hs :ConqueTermSplit bash -l<cr>
" nmap <silent> <leader>tvs :ConqueTermTab bash -l<cr>

function! RunCurrentInSplitTerm()

    " TODO can we replace this with :terminal ?
    call plug#load("Conque-Shell")

    let fileName = expand('%')
    let fullPath = expand('%:p:h')
    let winSize = 0.3
    let winSize = winSize * winheight('$')
    let winSize = float2nr(winSize)
    let mainWin = winnr()

    " make sure we're up to date
    write

    let found = 0
    let existing = {}
    if exists("g:ConqueTerm_Terminals")
        for [idx, term] in items(g:ConqueTerm_Terminals)
            if !has_key(term, 'bufname')
                continue
            endif

            let winnr = bufwinnr(term.bufname)
            if winnr != -1 && term.active != 0
                " update it, if it's changed
                if winnr != term.winnr
                    let term.winnr = winnr
                endif

                let existing = term
                let found = 1
            endif
        endfor
    endif

    " do we already have a term?
    if !found
        " nope... set it up

        " make sure it's executable
        silent !chmod +x %

        " TODO Apparently, winnrs can change (ex: when we
        "   open git-commit). Somehow we need to handle that...
        let mainBuf = bufnr('%')
        let term = conque_term#open('bash', ['below split', 
            \ 'resize ' .  winSize])
        let term.winnr = winnr()
        let term.winSize = winSize
        let term.bufname = bufname(bufnr('%')) " seems to not match buffer_name
        let b:mainBuf = mainBuf
        let b:fullPath = fullPath
        let b:fileName = fileName

        " NB Can't seem to unset the variable correctly,
        "  so we just check the active status

        exe 'inoremap <buffer> <d-r> <up><cr>'
        exe 'nnoremap <buffer> <d-r> i<up><cr>'
        exe 'inoremap <buffer> <c-l> <esc><c-w><c-l>'
    else
        " yes! reuse it
        let term = existing

        exe term.winnr . 'wincmd w'
        :startinsert
        exe 'resize ' . term.winSize
    endif

    " We're not really planning to do much real input 
    "  in this window, so let's take over the super-easy
    "  Tab to quickly jump back to our main window
    " Do this always, in case winnrs have changed
    exe 'inoremap <buffer> <Tab> <esc>:' . mainWin . 'wincmd w<cr>'

    exe 'inoremap <buffer> <c-b> <esc><c-b>'

    " always cd, just in case
    call term.writeln("cd " . fullPath)
    call term.writeln("clear")
    call term.writeln("./" . fileName)
endfunction
nmap <silent> <leader>rs :call RunCurrentInSplitTerm()<cr>
nmap <silent> <d-r> :call RunCurrentInSplitTerm()<cr>


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

if has('autocmd') && !exists('autocmds_loaded')
    let autocmds_loaded = 1

    " have some nice auto paths
    autocmd BufEnter * call SetPathToProject()
endif

function! FixLineEndingsFunc()
    update	 " Save any changes.
    e ++ff=dos	 " Edit file again, using dos file format 
    setlocal ff=unix	" This buffer will use LF-only line endings 
    w
endfunction

command! FixLineEndings call FixLineEndingsFunc()

function! DocToJson()
    :%!python -mjson.tool
    set ft=javascript
endfunction
command! JSON call DocToJson()


"
" :term stuff
"
let &shell = '/bin/bash -l'
function! WatchAndRunFunc()
    try
        let progs = { 'javascript': 'node',
                    \ 'python': 'python'
                    \ }
        let prog = progs[&ft]
        let file = expand('%')
        execute 'terminal when-changed -1sv ' . file . ' ' . prog . ' ' . file
    catch
        echo "No program known for " . &ft
    endtry
endfunction
command! WatchAndRun call WatchAndRunFunc()

"
" Open a terminal in the current directory
"
function! OpenTermFunc()
    silent exe "!osascript -e 'tell app \"Terminal\" to do script \"cd '" 
                   \ .  expand('%:p:h') . "' && clear\"'"
    silent !osascript -e 'tell app "Terminal" to activate'
endfunction
command! Term call OpenTermFunc()

