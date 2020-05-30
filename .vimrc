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

" using the same as the "local leader" for now
let maplocalleader = " "

" source the plug defs and settings
Source 'plugins.vim'

" now, source settings, maps, etc.
Source 'abbr.vim'
Source 'settings.vim'
Source 'commands.vim'
Source 'mappings.vim'

Source 'github.vim'
Source 'loclist.vim'
Source 'python.vim'
Source 'terminal.vim'

" NOTE: TEMPORARY

let g:ycm_language_server = [
    \ {
    \   'name': 'sparkling',
    \   'cmdline': ['/Users/dhleong/git/sparkling/run'],
    \   'filetypes': ['clojure'],
    \   'project_root_files': ['deps.edn', 'project.clj', 'shadow-cljs.edn'],
    \ }
    \ ]

func! ShowLogs()
    call feedkeys(":YcmToggleLogs spark\<tab>\<cr>", 'nt')
    call histdel(':', 'YcmToggleLogs spark.*')
endfunc

nnoremap <leader>yr :YcmCompleter RestartServer<cr>
nnoremap <leader>yt :call ShowLogs()<cr>

"
" My project path script init
"
augroup PathToProjectCmds
    " have some nice auto paths
    autocmd!
    autocmd BufEnter * call dhleong#projects#SetPathToProject()
augroup END
