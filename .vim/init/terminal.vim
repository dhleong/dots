
" ======= Settings =========================================

" use zsh, not bash
if filereadable("/usr/local/bin/zsh")
    set shell=/usr/local/bin/zsh
elseif filereadable("/bin/zsh")
    " catalina?
    set shell=/bin/zsh
elseif filereadable("/usr/bin/zsh")
    " windows bash, probably. Or actual linux, but maybe similar?
    set shell=/usr/bin/zsh

    if &term =~ '256color'
        " disable Background Color Erase (BCE) so that color schemes
        " render properly when inside 256-color tmux and GNU screen.
        " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
        set t_ut=
    endif
endif

" For Vim 7.4.1799 or later
if has('termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" ======= Run current file in a split :term ================

let s:filetypeRunCommands = {}
func! s:filetypeRunCommands.go(fileName)
    if stridx(a:fileName, "_test.go") != -1
        return 'go test .'
    else
        return 'go run ./' . a:fileName
    endif
endfunc

func! s:filetypeRunCommands.swift(fileName)
    return 'swift ' . a:fileName
endfunc

function! s:RunCurrentInSplitTerm()

    let fileType = &filetype
    let fileName = expand('%')
    let fullPath = expand('%:p:h')
    let winSize = 0.3
    let winSize = winSize * winheight('$')
    let winSize = float2nr(winSize)
    let mainBuf = bufnr('%')

    " make sure we're up to date
    write

    " do we already have a term?
    let termBufNr = get(b:, "_run_term", -1)
    let termWinNr = bufwinnr(termBufNr)
    if termWinNr == -1
        " nope... set it up

        " make sure it's executable
        silent !chmod +x %

        let mainBuf = bufnr('%')

        " manually split the window so we can open it how we want,
        "  and reuse the window via the curwin option
        exe 'below split | resize ' . winSize
        let termBufNr = term_start(&shell, {
                    \ 'curwin': 1,
                    \ 'term_finish': 'close',
                    \ })

        " save the bufnr so we can find it again
        call setbufvar(mainBuf, "_run_term", termBufNr)

        exe 'tnoremap <buffer> <d-r> <up><cr>'
        exe 'tnoremap <buffer> <c-l> <esc><c-w><c-l>'
        exe 'nnoremap <buffer> <c-d> i<c-d>'
        exe 'nnoremap <buffer> <d-r> i<up><cr>'
    else
        " yes! reuse it
        exe termWinNr . 'wincmd w'

        " is there a better way to focus on it?
        call feedkeys("i\<bs>", 't')
        call term_wait()
    endif

    " We're not really planning to do much real input
    "  in this window, so let's take over the super-easy
    "  Tab to quickly jump back to our main window
    " Do this always, in case winnrs have changed
    let mainWin = bufwinnr(mainBuf)
    exe 'tnoremap <buffer> <Tab> <c-w>N:' . mainWin . 'wincmd w<cr>'
    exe 'nnoremap <buffer> <Tab> :' . mainWin . 'wincmd w<cr>'

    let CmdValue = get(s:filetypeRunCommands, fileType, '')
    let cmd = ""
    if type(CmdValue) == v:t_func
        let cmd = s:filetypeRunCommands[fileType](fileName)
    else
        let cmd = cmd . " ./" . fileName
    endif

    " allow user to modify the command by typing it
    " (for example adding DEBUG=*)
    let lastCmd = get(b:, "_last_term_cmd", "")
    if lastCmd =~# cmd
        let cmd = lastCmd
    endif

    " always cd, just in case
    call term_sendkeys(termBufNr, "cd " . fullPath . "\<cr>")
    call term_sendkeys(termBufNr, "clear\<cr>")
    call term_sendkeys(termBufNr, cmd . "\<cr>")
endfunction
nnoremap <silent> <leader>rs :call <SID>RunCurrentInSplitTerm()<cr>
nnoremap <silent> <d-r> :call <SID>RunCurrentInSplitTerm()<cr>

func! Tapi_dhl_onTerm(bufnr, command)
    call setbufvar(a:bufnr, "_last_term_cmd", a:command)
endfunc
