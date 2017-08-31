" This must be first, because it changes other options as side effect
set nocompatible

" `Source` command def {{{
function! SourceInitFileFunc(path)
    let path = resolve(expand('~/.vim/init/' . a:path))
    exec "source " . path
endfunction
command! -nargs=1 Source :call SourceInitFileFunc(<args>)
" }}}

" source the plug defs
Source 'plugins.vim'

" ======= Global settings ==================================

Source 'settings.vim'
Source 'mappings.vim'

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

" paredit configs
let g:paredit_leader = ","

" Clean up trailing whitespace
function! TryCleanWhitespace()

    " minus 1 to be zero-indexed;
    " minus another because we're in insert mode
    let col = col('.') - 2
    let line = getline('.')[:col]
    let whitespace = len(matchstr(line, '\s*$'))
    " echom line . ' -> ' . whitespace
    if len(line) == whitespace
        let prefix = ''
    else
        let prefix = repeat("\<BS>", whitespace)
    endif

    return prefix . "\<Enter>"
endfunction
inoremap <expr> <Enter> TryCleanWhitespace()

" livedown
let g:livedown_autorun = 1

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


" dash
nnoremap <leader>K :Dash<cr>
nnoremap gK :Dash!<cr>
" nnoremap <C-S-k> :Dash " overrides <c-k> for some reason
let g:dash_map = {
    \ 'javascript': 'electron',
    \ 'typescript': ['typescript', 'javascript']
    \ }

" eregex config
let g:eregex_default_enable = 0  " doesn't do incremental search, so no
nnoremap <leader>\ :call eregex#toggle()<CR>

" some git configs
nnoremap <leader>gc :Gcommit -a<CR>
nnoremap <leader>ga :Gcommit -a --amend<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR><c-w>=
nnoremap <leader>gb :Gblame<CR>
set diffopt=filler,vertical

function! WriteAndPush()
    if expand('%') == "COMMIT_EDITMSG" || expand('%:h') == "COMMIT_EDITMSG"
        :Gwrite
        " :Git push
        !git --no-pager push
    else
        " :Git push
        !git --no-pager push
    endif
endfunction
nnoremap <leader>gp :call WriteAndPush()<CR>

function! PushNewUpstream()
    let start = "ref: refs/heads/"
    let branch = fugitive#repo().head_ref()
    if branch[:len(start)-1] != start
        echo "Unexpected: " . branch[:len(start)]
        return
    endif
    let branch = branch[len(start):]
    echo system('git --no-pager push -u origin ' . branch)
endfunction
nnoremap <leader>gu :call PushNewUpstream()<CR>

" Tweaking {} motion behavior
let g:ip_boundary = '[" *]*\s*$'
" don't open folds when jumping over blocks
let g:ip_skipfold = 1


"
" some abbreviations/typo fixes
"

" I do this ALL the time
abbr ~? ~/
iabbr CLoses Closes
iabbr mfa Miners/minus-for-Android

"
" Sparkup/zen coding
"
let g:sparkupExecuteMapping = '<c-z>'

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
" Quick todo list using grep and quickfix
"
function! SetTitleAndClearAutoCmd()
    setl statusline="Quick Todo List"
    au! BufWinEnter quickfix
endfunction

function! OpenTodoListFunc()
    " we just use the tasklist var for tokens
    if !exists('g:tlTokenList')
        let g:tlTokenList = ["FIXME", "TODO", "XXX", "STOPSHIP"]
    endif

    autocmd BufWinEnter quickfix call SetTitleAndClearAutoCmd()
    cgetexpr system("grep -IERn '" . join(g:tlTokenList, '\|') . "' " . g:ProjectGrepPath)
    copen
endfunction

command! OpenTodoList call OpenTodoListFunc()

nmap <leader>T :OpenTodoList<cr>
nmap <leader>tq :sign unplace *<cr> :LocationListClear<cr>

" jedi configs
let g:jedi#completions_enabled = 0
let g:jedi#squelch_py_warning = 1
let g:jedi#popup_select_first = 1
let g:jedi#popup_on_dot = 0
let g:jedi#goto_definitions_command = "gd"
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#use_splits_not_buffers = "right"

" tern configs
let g:tern_show_signature_in_pum = 1

" session configs
let g:session_autosave = 'yes'
let g:session_autoload = 'no'

" airline configs
set laststatus=2
let g:airline#extensions#whitespace#enabled = 0
" let g:airline#extensions#eclim#enabled = 0
let g:airline#extensions#default#section_truncate_width = {
  \ 'x': 88,
  \ 'y': 88,
  \ 'z': 45,
  \ }

" only use powerline fonts if we have it. This was moved
"  from .gvimrc because it apparently no longer runs
"  before airline does its config step, so was ignored
let _fontName='Inconsolata+for+Powerline.otf'
if has('gui_running') 
        \ && (!empty(glob("~/Library/Fonts/" . _fontName))
            \ || !empty(glob("~/Library/Fonts/" . substitute(_fontName, '+', ' ', 'g'))))
    " could check more places, but....
    let g:airline_powerline_fonts = 1
endif


" ale configs
let g:ale_linters = {
    \   'javascript': ['eslint'],
    \   'typescript': ['tslint'],
    \}

" syntastic configs
" let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
let g:syntastic_cs_checkers = []
let g:syntastic_javascript_checkers = []
let g:syntastic_javascript_eslint_exec = '~/.npm-packages/bin/eslint'
let g:syntastic_javascript_jshint_exec = '~/.npm-packages/bin/jshint'
let g:syntastic_java_checkers = []
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_quiet_messages = {
    \ "regex": [
        \ 'proprietary.*async',
        \ 'proprietary.*onload',
        \ 'proprietary.*onreadystatechange',
    \ ]}

function! FallbackJumpToNextError()
    try
        lnext
    catch /.*No.more.items$/
        lfirst
    catch /.*No.Errors$/
        echohl WarningMsg
        echo "No errors :)"
        echohl None
    catch /.*No.location.list$/
    endtry
endfunction

function! JumpToNextError()

    if &ft == "java" || &ft == "cs" || &ft == "cpp"
        " make sure diagnostics are up-to-date
        :YcmForceCompileAndDiagnostics 
        redraw!

        call FallbackJumpToNextError()
        return
    endif

    if !exists("g:SyntasticLoclist")
        return
    endif

    let loclist = g:SyntasticLoclist.current()
    call loclist.sort()
    let rawlist = loclist.getRaw()
    if !len(rawlist)
        call FallbackJumpToNextError()
        return
    endif

    let thisLine = line('.')
    let myIssue = {"found": 0}
    for issue in rawlist
        if issue.lnum > thisLine
            let myIssue = issue
            let myIssue.found = 1
            break
        endif
    endfor

    if myIssue.found == 0
        let myIssue = rawlist[0]
    endif

    echo myIssue.text
    exe 'norm ' . myIssue.lnum . 'G<cr>'
endfunction
nnoremap <silent> <d-.> :call JumpToNextError()<cr>
nmap <silent> ]c :call JumpToNextError()<cr>

" 
" Ycm configs
"
let g:ycm_filetype_blacklist = {
    \ 'tagbar' : 1,
    \ 'qf' : 1,
    \ 'notes' : 1,
    \ 'unite' : 1,
    \ 'vimwiki' : 1,
    \ 'pandoc' : 1,
    \ 'conque_term' : 1,
    \}

let g:ycm_filter_diagnostics = {
    \   'cs': {
    \     'regex': [
    \       "Convert to 'return' statement",
    \       "Convert to '&=' expresssion",
    \       "Convert to '&=' expression",
    \       "prefix '_'",
    \       "Parameter can be ",
    \       "Redundant argument name specification",
    \       "Use 'var' keyword",
    \       "Xml comment",
    \     ]
    \   },
    \   'cpp': {
    \     'regex': [
    \       "enumeration in a nested name specifier",
    \     ]
    \   }
    \ }

let g:ycm_extra_conf_globlist = ["~/git/juuce/*"]

" let g:ycm_semantic_triggers = {
"     \ 'android-xml' : [':', '="', '<', '/', '@']
"     \}

let g:ycm_key_list_previous_completion = ['<Up>'] " NOT s-tab; we do the right thing below:
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<c-d>"

" most useful for gitcommit
let g:ycm_collect_identifiers_from_comments_and_strings = 1

let g:ycm_always_populate_location_list = 1

" let g:ycm_max_diagnostics_to_display = 50

let g:UltiSnipsListSnippets="<C-M-Tab>"
let g:UltiSnipsExpandTrigger="<C-Enter>"
let g:UltiSnipsJumpForwardTrigger="<C-J>"
let g:UltiSnipsJumpBackwardTrigger="<C-K>"

"
" Commenting configs
"
let g:tcomment_types = {
    \ 'java': '// %s',
    \ 'java_inline': '/* %s */',
    \ 'java_block': '// %s'
    \ }

"
" targets.vim
"
" swap I and i so >iB works as expected
let g:targets_aiAI = 'aIAi'

"
" Github fun
"
let g:gh_cmd = "/Users/dhleong/code/hubr/gh-cmd"
function! GithubAcceptFunc()
    let ticket=expand("<cword>")
    call hubr#tag(ticket, 'accepted')
    echo "Accepted Github ticket #" . ticket
endfunction
command! GithubAccept call GithubAcceptFunc()

function! GithubTakeFunc()
    let ticket=expand("<cword>")
    call hubr#assign(ticket, hubr#me_login())
    echo "Took Github ticket #" . ticket
endfunction
command! GithubTake call GithubTakeFunc()

function! GithubOpenFunc()
    let ticket=expand("<cword>")
    let repo=hubr#repo_name()
    let cmd=":silent !open http://github.com/" . repo . "/issues/" . ticket
    exe cmd
endfunction
command! GithubOpen call GithubOpenFunc()


" mark the issue number under the cursor as accept
nnoremap gha :GithubAccept<cr>

" 'take' the issue under the cursor (assign to 'me')
nnoremap ght :GithubTake<cr>
"
" open the issue under the cursor 
nnoremap gho :GithubOpen<cr>

" awesome Unite plugin for issues
nnoremap ghi :Unite gh_issue:state=open<cr>
" nnoremap ghi :Unite gh_issue:state=open:milestone?<cr>

" only auto-ref issues assigned to me
let g:hubr#auto_ref_issues_args = 'state=open:assignee=dhleong:milestone?'

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

" also
let g:markdown_fenced_languages = ['coffee', 'css', 'java', 'javascript',
    \ 'js=javascript', 'json=javascript', 'clojure', 'sass', 'xml', 'html']


nmap <Leader>ijf <Plug>IMAP_JumpForward

"
" Open a terminal in the current directory
"
function! OpenTermFunc()
    silent exe "!osascript -e 'tell app \"Terminal\" to do script \"cd '" 
                   \ .  expand('%:p:h') . "' && clear\"'"
    silent !osascript -e 'tell app "Terminal" to activate'
endfunction
command! Term call OpenTermFunc()

" sneak configs
let g:sneak#streak = 1

