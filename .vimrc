" This must be first, because it changes other options as side effect
set nocompatible

let g:ale_emit_conflict_warnings = 0

" vim-plug
    if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall
    endif

    call plug#begin('~/.vim/bundle')

    "Add your bundles here
    " FIXME: find proper homes for these:
    Plug 'vim-scripts/eregex.vim'
    Plug 'vim-scripts/matchit.zip'
    Plug 'vim-scripts/VisIncr'
    Plug 'vim-scripts/zenburn'
    Plug 'vim-scripts/ShaderHighLight'

    " use ap's fork here instead of skammer, to add stylus support
    " NB: css-color breaks if loaded on-demand
    Plug 'ap/vim-css-color'
    Plug 'bling/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'davidhalter/jedi-vim', {'for': 'python', 'do': 'git submodule update --init'}
    Plug 'dhleong/vim-veryhint', {'for': 'java'}
    Plug 'fatih/vim-go'
    Plug 'guns/vim-clojure-static', {'for': 'clojure'}
    Plug 'guns/vim-clojure-highlight', {'for': 'clojure'}
    Plug 'guns/vim-sexp', {'for': 'clojure'}
    Plug 'haya14busa/vim-textobj-function-syntax' | Plug 'kana/vim-textobj-function'
    Plug 'Julian/vim-textobj-variable-segment'
    " Plug 'junegunn/vim-peekaboo'
    Plug 'junegunn/vim-pseudocl'
    " Plug 'junegunn/vim-oblique', {'on': ['<Plug>(Oblique-/)', '<Plug>(Oblique-?)',
    "             \ '<Plug>(Oblique-F/)', '<Plug>(Oblique-F?)']}
    Plug 'junegunn/vader.vim', {'for': 'vader'}
    Plug 'justinmk/vim-ipmotion'
    Plug 'justinmk/vim-sneak'
    Plug 'kana/vim-textobj-user'
    Plug 'marijnh/tern_for_vim', {'for': 'javascript', 'do': 'npm install'}
    Plug 'moll/vim-node', {'for': 'javascript'}
    Plug 'OmniSharp/omnisharp-vim', {'for': 'cs', 'do': 'git submodule update --init --recursive && cd server && xbuild'}
    Plug 'oplatek/Conque-Shell', {'on': ['RunCurrentInSplitTerm', 'ConqueTermTab',
        \ 'ConqueTermSplit', 'ConqueTermVSplit']}
    Plug 'osyo-manga/vim-over'
    Plug 'rizzatti/dash.vim'
    Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
    Plug 'rstacruz/sparkup', {'rtp': 'vim', 'for': 'html'}
    Plug 'scrooloose/syntastic'
    Plug 'Shougo/unite.vim'
    Plug 'Shougo/vimproc.vim', {'do': 'make'}
    " Plug 'shime/vim-livedown'
    Plug 'suan/vim-instant-markdown', {'for': 'markdown',
        \ 'do': 'sudo gem install redcarpet pygments.rb && sudo npm -g install instant-markdown-d'}
    Plug 'terryma/vim-multiple-cursors'
    Plug 'tommcdo/vim-exchange'
    Plug 'tomtom/tcomment_vim'
    Plug 'tpope/vim-fireplace', {'for': 'clojure'}
    " Plug '~/git/vim-fireplace', {'for': 'clojure'}
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-markdown', {'for': 'markdown'}
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-scriptease', {'for': 'vim'}
    Plug 'tpope/vim-sexp-mappings-for-regular-people', {'for': 'clojure'}
    " Plug 'tpope/vim-sleuth'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-vinegar'
    " Plug 'vimwiki/vimwiki'
    Plug 'Valloric/MatchTagAlways', {'for': ['html', 'xml']}
    if !(has('nvim') || exists('g:neojet#version'))
        Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --omnisharp-completer --tern-completer'}
        " Plug '~/git/YouCompleteMe', {'do': './install.py --omnisharp-completer'}
    endif
    Plug 'wellle/targets.vim'
    Plug 'w0rp/ale', {'for': ['javascript', 'typescript']}
    Plug 'xolox/vim-misc'
    Plug 'xolox/vim-session'

    " Plug 'file:///Users/dhleong/code/hubr'
    Plug '~/git/hubr'
    " Plug '~/git/intellivim', {'rtp': 'vim'}
    " Plug 'file:///Users/dhleong/code/njast'
    " Plug 'file:///Users/dhleong/git/Conque-Shell'
    Plug '~/git/lily'
    Plug '~/git/vim-latte'

    " I would prefer to user MarcWeber's,
    "  but it seems to be broken with YCM
    " Plug 'MarcWeber/ultisnips'
    Plug 'SirVer/ultisnips' | Plug '~/git/vim-cs-snippets' | Plug 'honza/vim-snippets'

    " Syntax plugins
    Plug 'digitaltoad/vim-jade'
    Plug 'groenewege/vim-less'
    Plug 'kchmck/vim-coffee-script'
    Plug 'LokiChaos/vim-tintin'
    Plug 'udalov/kotlin-vim'
    Plug 'keith/swift.vim'
    Plug 'tfnico/vim-gradle'
    Plug 'wavded/vim-stylus'
    Plug '~/git/vim-interspace'
    Plug '~/git/vim-jsgf'

    " typescript
    Plug 'leafgarland/typescript-vim'
    Plug 'jason0x43/vim-js-indent', {'for': 'typescript'}

    " jsx depends on panglass/vim-javascript:
    Plug 'mxw/vim-jsx' | Plug 'pangloss/vim-javascript'

    call plug#end()
" Setting up vim-plug end

" A convenient function to delete a bundle and reinstall it
function! ReinstallPlugin(name)
    " PluginList
    " exe '/' . a:name
    " norm D
    " PluginInstall
    " norm q
    exe '!rm -rf ~/.vim/bundle/' . a:name . '/'
    exe "PlugUpdate! " . a:name

    " if a:name == 'njast'
    "     !cd ~/.vim/bundle/njast && npm install
    " endif
endfunction


set autoindent
set copyindent    " copy the previous indentation on autoindenting
set showcmd
set incsearch
syntax enable
filetype plugin on
set tabstop=4
set shiftwidth=4
set expandtab
set ruler       " we may want to know where we are in the file

set ignorecase  " ignore case in search....
set smartcase   " but if we WANT case, use it

set splitright  " horizontal splits should not open on the left... 
set noea        " 'no equal always'--don't resize my splits!

set updatetime=900

if exists('+autochdir')
    " use the builtin if we have it
    set autochdir
else
    " use the manual method 
    autocmd BufEnter * silent! lcd %:p:h
endif

" use cursorline, but only for current window (nice)
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

"colorscheme desert
colorscheme zenburn

" longest submatch, but subsequent tabs keep going
set wildmode=longest:full,full

set wildignore=.svn,.git,*.o,*.a,*.class,*.pyc
set wildignore+=*.mo,*.la,*.so,*.obj,*.swp,*.swo
set wildignore+=*.jpg,*.png,*.xpm,*.gif,*.pdf,*.bak
set wildignore+=*.beam,*~,*.info,*.meta

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

" visual bell
set vb

" hide useless gui
set guioptions=c

" show horrid tabs
set list
set listchars=tab:»·,trail:·

" use comma as the map leader, because \ is too far
" let mapleader = ","
" actually, let's try space... much easier to hit
let mapleader = " "

let $_MYVIMRC = resolve($MYVIMRC)

" Let's make it easy to edit this file (mnemonic for the key sequence is
" 'e'dit 'v'imrc)
nmap <silent> <leader>ev :e $_MYVIMRC<cr>

" And, in a new tab
nmap <silent> <leader>tev :tabe $_MYVIMRC<cr>

" And the bundles dir, as well ('v'im 'b'undles)
nmap <silent> <expr> <leader>vb ":e " . resolve("~/.vim/bundle/") . "<cr>"

" Edit the filetype file of the current file in a new tap
nnoremap <silent> <expr> <leader>eft ":tabe " . resolve(join([$HOME, "/.vim/ftplugin/", &filetype, ".vim"], "")) . "<cr>"

" Open the bash profile
nnoremap <silent> <expr> <leader>eb ":e " . resolve("~/.bash_profile") . "<cr>"
nnoremap <silent> <expr> <leader>teb ":tabe " . resolve("~/.bash_profile") . "<cr>"
nnoremap <silent> <expr> <leader>ep ":e " . resolve("~/.bash_profile") . "<cr>"
nnoremap <silent> <expr> <leader>tep ":tabe " . resolve("~/.bash_profile") . "<cr>"

" tabclose
nnoremap <silent> <leader>tc :tabclose<cr>

" find a build.gradle
function! FindGradle() 
    try
        find! ./build.gradle
    catch
        find build.gradle
    endtry
endfunction
nnoremap <silent> <leader>og :call FindGradle()<cr>

" paredit configs
let g:paredit_leader = ","

" Also, just source it automatically on write
augroup VimAutoSource
    autocmd!
    autocmd BufWritePost .vimrc source %
augroup END

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

" convenient new tab
nnoremap <C-W><C-W> :tabe<cr>

" Enable faster splits navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" And, faster tab navigation
nnoremap H gT
nnoremap L gt
nnoremap zh H
nnoremap zl L

" Navigation in insert mode, for use with multicursor
inoremap <C-A> <esc>I
inoremap <C-E> <esc>A

" dash
nnoremap <leader>K :Dash<cr>
nnoremap gK :Dash!<cr>
" nnoremap <C-S-k> :Dash " overrides <c-k> for some reason
let g:dash_map = {
    \ 'javascript': 'electron',
    \ 'typescript': ['typescript', 'javascript']
    \ }


" Ctrl-S 2x to open a vertical split (I use these a lot)
" It's 2x because <C-S><C-P> does Unite Search to open in vsp,
"  so this is faster if I just want a straight split
nnoremap <C-S><C-S> :vsp<cr>

" fast window resize
nnoremap <leader>= <C-W>10+
nnoremap <leader>- <C-W>10-

function! WindowFocusFunc() 
    call feedkeys("\<c-w>=", "n")
    call feedkeys("\<c-w>15+", "n")
    call feedkeys("\<c-w>15>", "n")
endfunction
nnoremap <silent> <leader>wf :call WindowFocusFunc()<cr>

" " Make better use of <space> (should it be leader?)
" nmap <silent> <space> <enter>

" Make unfolding easier
nnoremap + zA


" Quick make 
function! CompileLess()
    if expand('%:p:h:t') == 'less'
        silent !lessc % ../resources/public/css/%:t:r.css > /dev/null
    else
        silent !lessc % %:t:r.css > /dev/null
    endif

    " " quickly open, write, and close the file.
    " " this helps trick Tincr into reloading
    " " the updated css file more reliably
    " silent new %:t:r.css
    " silent w
    " silent q
endfunction
function! MapMake()
    if &ft == 'less'
        " the make shortcut should just compile lesscss
        nnoremap <silent> <leader>mm :w<cr> <BAR> call CompileLess()
    elseif expand('%:p') == $MYVIMRC
        " make green
        nmap <silent> <leader>mm :PluginInstall<cr>
    elseif &ft == 'javascript'
        " make green
        nmap <silent> <leader>mm :MakeGreen<cr>
    else
        " otherwise, just make
        nmap <silent> <leader>mm :make<cr>
    endif 
endfunction
augroup MakeMapper
    autocmd!
    autocmd BufEnter * call MapMake()
augroup END

" Quick make clean
nmap <silent> <leader>mc :make clean<cr>

" Quick make and run
nmap <silent> <leader>mr :make run<cr>

" ctrl+tab between tabs
nmap <silent> <C-Tab> :tabn<cr>
nmap <silent> <C-S-Tab> :tabp<cr>

" ctrl+a to get to front of line in commandline mode
cnoremap <C-A> <Home>

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

" super tab and other completion settings
let g:SuperTabNoCompleteAfter = ['//', '\s', ',', '#']
let g:SuperTabNoCompleteBefore = ['\w']
let g:SuperTabLongestEnhanced = 1
let g:SuperTabLongestHighlight = 1
let g:SuperTabMappingBackward = '<s-c-space>' " don't override our custom guy!

" use shift-tab in normal mode, or insert mode with no popup, to unindent
" crazy redundancy required because just <C-p> goes forward, for some
" reason (although the c-n c-p thing works as expected. weird)
inoremap <expr><S-Tab> pumvisible()? "\<down>\<C-n>\<C-p>" : "\<c-d>"
nnoremap <S-Tab> <<_
nnoremap <Tab> >>_

" If we have suggestions open, we want some keys
" to accept the suggestion *and* add their key, 
" for more fluid typing
let acceptSuggestionKeys = ['<Space>', '.', ',', ':', ';', '(', ')', '[', ']']
for key in acceptSuggestionKeys
    exe 'imap <expr>' . key . ' pumvisible() ? "\<C-y>' . key . '" : "' . key . '"'
endfor

set completeopt=menu,preview,longest

"
" some abbreviations/typo fixes
"

" I do this ALL the time
abbr ~? ~/
iabbr CLoses Closes
iabbr mfa Miners/minus-for-Android

" if &ft != 'gitcommit'
"     inoremap <buffer> #env #!/usr/bin/env 
" endif

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
        exe 'set path=.,/usr/include,,'
    endif

    " reset ctrl-p to default
    call MapCtrlP("")
endfunction

" let's always provide this, so we can use it in new tabs, etc.
nnoremap <silent> <leader>lf :LocateFile<cr>

function! ConfigureJava()

    if exists("*intellivim#InProject") && intellivim#InProject()
        nnoremap <buffer> <silent> <leader>fi :JavaOptimizeImports<cr>
        nnoremap <buffer> <silent> <leader>jc :FixProblem<cr>
        nnoremap <buffer> <silent> K :GetDocumentation<cr>
        nnoremap <buffer> <silent> gd :GotoDeclaration<cr>
        nnoremap <buffer> <silent> <leader>lf :Locate<cr>
        nnoremap <buffer> <silent> <leader>lc :Locate class<cr>
        nnoremap <buffer> <silent> <leader>ji :Implement<cr>

        nnoremap <buffer> <silent> <leader>pr :RunProject<cr>
        nnoremap <buffer> cpr :RunTest<cr>
    else
        nnoremap <buffer> <silent> <leader>fi :JavaImportOrganize<cr>
        nnoremap <buffer> <silent> <leader>jc :JavaCorrect<cr>
        nnoremap <buffer> <silent> <leader>ji :JavaImpl<cr>
        nnoremap <buffer> <silent> K :JavaDocPreview<cr>
        nnoremap <buffer> <silent> gd :JavaSearch -x implementors -s workspace<cr>
        nnoremap <buffer> <silent> <leader>lf :LocateFile<cr>
        nnoremap <buffer> <silent> <leader>lc :LocationListClear<cr>

        nnoremap <buffer> <silent> <leader>pr :ProjectRun<cr>
        nnoremap <buffer> cpr :JUnit<cr>
        nnoremap <buffer> cpt :JUnit %<cr>
    endif

    nmap <buffer> <silent> <leader>pp :ProjectProblems!<cr>
    nmap <buffer> <silent> <leader>jf :JavaCorrect<cr>
    nmap <buffer> <silent> <leader>jd :JavaDocSearch<cr>
    nmap <buffer> <silent> <leader>js :JavaSearch -x declarations -s project<cr>
    nmap <buffer> <silent> <leader>jr :JavaSearch -x references -s project<cr>
    nmap <buffer> <silent> <leader>ll :lopen<cr>
    nmap <buffer> <silent> <m-1> :JavaCorrect<cr>

    " let c-n do the regular local search
    inoremap <buffer> <c-n> <c-x><c-n>

    " the one above doesn't cooperate here, either...
    inoremap <buffer> <expr><S-Tab> pumvisible()? "\<up>\<C-n>\<C-p>" : "\<c-d>"
endfunction

function! ConfigurePython()
    nmap <silent> <F19> :!python %<cr>
    "let <buffer> g:SuperTabDefaultCompletionType = "<c-x><c-o>"
    "call SuperTabSetDefaultCompletionType("<c-x><c-o>")

    " let c-n do the regular local search
    inoremap <buffer> <c-n> <c-x><c-n>

    " the one above doesn't cooperate with vim-jedi for some reason
    inoremap <buffer> <expr><S-Tab> pumvisible()? "\<up>\<C-n>\<C-p>" : "\<c-d>"

endfunction

function! ConfigureAndroidProject()
    if !exists(":PingEclim")
        return
    endif

    let project = eclim#project#util#GetCurrentProjectName()
    if empty(project)
        return
    endif

    let natures = eclim#project#util#GetProjectNatureAliases(project)
    if -1 == index(natures, "android")
        return
    endif

    " OKAY! We're an android project
    let root = eclim#project#util#GetProjectRoot(project)
    let root = escape(root, ' ')
    exe 'nnoremap <buffer> <leader>ob :edit ' . root . '/build.gradle<cr>'
    exe 'nnoremap <buffer> <leader>om :edit ' . root . '/AndroidManifest.xml<cr>'
    exe 'nnoremap <buffer> <leader>or :edit ' . root . '/res<cr>'
    exe 'nnoremap <buffer> <leader>ov :edit ' . root . '/res/values<cr>'
    exe 'nnoremap <buffer> <leader>od :edit ' . root . '/res/values/dimens.xml<cr>'
    exe 'nnoremap <buffer> <leader>os :edit ' . root . '/res/values/strings.xml<cr>'
    exe 'nnoremap <buffer> <leader>ot :edit ' . root . '/res/values/styles.xml<cr>'
    exe 'nnoremap <buffer> <leader>ol :edit ' . root . '/res/layout<cr>'

endfunction

if has('autocmd') && !exists('autocmds_loaded')
    let autocmds_loaded = 1

    " some java stuff
    autocmd BufEnter *.java call ConfigureJava()
    "autocmd BufWrite *.java silent! JavaImportOrganize " import missing on save
    
    autocmd BufEnter *.py call ConfigurePython()

    " let K call vim 'help' when in a vim file
    autocmd FileType vim nnoremap <buffer> K :exe 'help ' .expand('<cword>')<cr>

    autocmd BufWritePost *.less call CompileLess()

    " have some nice auto paths
    autocmd BufEnter * call SetPathToProject()

    " " Use omnifunc when available, and chain back to normal
    " if g:useYcmCompletion == 0
    "     autocmd FileType * 
    "         \ if &omnifunc != '' |
    "         \   call SuperTabChain(&omnifunc, "<c-x><c-n>") |
    "         \   call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
    "         \ endif
    " endif

    augroup AndroidShortcuts
        autocmd BufEnter *.java call ConfigureAndroidProject()
        autocmd BufEnter *.xml call ConfigureAndroidProject()
    augroup END
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

" let g:EclimDisabled=0
let g:EclimJavaImplAtCursor = 1 " my old one
let g:EclimJavaImplInsertAtCursor = 1 
let g:EclimJavascriptValidate = 0 
let g:EclimCompletionMethod = 'omnifunc'
let g:EclimBuffersDefaultAction = 'edit'
let g:EclimLocateFileDefaultAction = 'edit'
let g:EclimHighlightSuccess = 'IncSearch'

":source /Users/dhleong/code/vim-javadocer/javadocer.vim
" silent! source /Users/dhleong/code/njast/njast.vim

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

" re-install hubr for rapid development
nnoremap <leader>rh :call ReinstallPlugin('hubr')<cr>

" re-install intellivim for rapid development
nnoremap <leader>ri :call ReinstallPlugin('IntelliVim')<cr>

" re-install njast for rapid development
nnoremap <leader>rn :call ReinstallPlugin('njast')<cr>

" re-install Conque-Shell for rapid development
nnoremap <leader>rs :call ReinstallPlugin('Conque-Shell')<cr>

" re-install veryhint for rapid development
nnoremap <leader>rv :call ReinstallPlugin('vim-veryhint')<cr>

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

"
" njast config (basically for testing)
"
let g:njast#port = 3000

"
" Convenience for Markdown editing
"
let g:markdown_tmp_file = $HOME . '/.tmp.markdown'
function! MarkdownFunc()
    silent exe "!rm " . g:markdown_tmp_file
    silent exe "edit " . g:markdown_tmp_file
    echo "Editing new Markdown file"
endfunction
command! Markdown call MarkdownFunc()

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

" " oblique configs; be fuzzy by default
" nmap z/ <Plug>(Oblique-/)
" nmap z? <Plug>(Oblique-?)
" nmap / <Plug>(Oblique-F/)
" nmap ? <Plug>(Oblique-F?)
" " the oblique versions of these don't actually move
" "  the cursor for some backward-ass reason.
" "  map them to somewhere out of the way so the real
" "  motions aren't clobbered
" nmap <c-*> <Plug>(Oblique-*)
" nmap <c-#> <Plug>(Oblique-#)
" nmap <m-*> <Plug>(Oblique-g*)
" nmap <m-#> <Plug>(Oblique-g#)

" sneak configs
let g:sneak#streak = 1

" get unicode pairs
function! GetUnicodePairs()
    " copy the output of the ascii command
    redir => raw
        ascii
    redir END

    " strip out the hex part and parse to int
    let match = matchlist(raw, 'Hex \(.*\),')
    let hex = match[1]
    let s = str2nr(hex, 16)

    " source: http://www.russellcottrell.com/greek/utilities/surrogatepaircalculator.htm
    if (s >= 0x10000 && s <= 0x10FFFF)
        let hi = float2nr(floor((s - 0x10000) / 0x400) + 0xD800)
        let lo = float2nr(((s - 0x10000) % 0x400) + 0xDC00)
        let pairs = printf('\u%x\u%x', hi, lo)

        " go ahead and copy it to the clipboard
        let @* = pairs
    else
        let pairs = '(none)'
    endif

    " clear old output and echo new
    redraw! 
    echo raw[1:] . ', Pairs ' . pairs
endfunction

nnoremap ga :call GetUnicodePairs()<cr>
