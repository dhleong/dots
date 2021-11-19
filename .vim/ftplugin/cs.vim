
" let g:ycm_enable_diagnostic_signs = 0
" let g:ycm_show_diagnostics_ui = 0

"
" Function defs
"

function! s:FindProjectRoot()
    let cwd = expand('%:p:h')
    let home = expand('~')
    while cwd !=# '/' && cwd != home
        let dir = cwd . '/ProjectSettings'
        let glob = glob(dir, 1)
        if glob !=# ''
            return cwd
        endif

        let cwd = fnamemodify(cwd, ':h')
    endwhile

    return ''
endfunction

let s:path = expand('<sfile>:p:h')
function! s:RunProject(mode)
    if !system('pgrep Unity')
        " can we start the project directly?
        let projectRoot = <SID>FindProjectRoot()
        if projectRoot !=# ''
            echo 'Starting Unity...'
            call system('/Applications/Unity/Unity.app/Contents/MacOS/Unity -projectPath ' . projectRoot . ' &')
            return
        endif
    endif

    silent exe 'silent !osascript ' . s:path . '/cs-' . a:mode . '-project.applescript'
    echo 'Project playing!'
endfunction

function! MyGetCSIndent(lnum) abort

    let this_line = getline(a:lnum)
    let previous_line = getline(a:lnum - 1)

    " Hit the start of the file, use zero indent.
    if a:lnum == 0
        return 0
    endif

    if previous_line =~? '^\s*\[[A-Za-z]' && previous_line =~? '\]$'
        " If previous_line is an attribute line:
        let ind = indent(a:lnum - 1)
        return ind
    elseif previous_line =~# '=>\s*$' && this_line =~# '{'
        return cindent(a:lnum - 1)
    else
        return cindent(a:lnum)
    endif

endfunction

"
" Settings
"

setlocal indentexpr=MyGetCSIndent(v:lnum)
let b:did_indent = 1

"
" Mappings
"
call dhleong#completer().MapNavigation()

nnoremap <buffer> <leader>ji :OmniSharpFixUsings<cr>

nnoremap <buffer> <silent> <leader>pb :call <SID>RunProject('build')<cr>
nnoremap <buffer> <silent> <leader>pr :call <SID>RunProject('run')<cr>

" Let the matchit plugin know what items can be matched.
if exists('loaded_matchit')
    let b:match_ignorecase = 0
    let b:match_words = &matchpairs . ',' .
                \'^#region::^#endregion'
    " let b:match_skip = 'string\|character'
    let b:match_skip = 's:comment\|string\|regex\|character'
endif
