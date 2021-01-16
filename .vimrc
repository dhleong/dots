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

" try to configure python *first* so plugins.vim is aware
Source 'python.vim'

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

"
" My project path script init
"
augroup PathToProjectCmds
    " have some nice auto paths
    autocmd!
    autocmd BufEnter * call dhleong#projects#SetPathToProject()
augroup END
