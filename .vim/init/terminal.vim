
" ======= Settings =========================================

" use zsh, not bash
if filereadable("/usr/local/bin/zsh")
    set shell=/usr/local/bin/zsh
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


" ======= Run current file in a split :term ================

function! s:RunCurrentInSplitTerm()

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
        let termBufNr = term_start('bash -l', {
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
        call feedkeys('i', 't')
    endif

    " We're not really planning to do much real input
    "  in this window, so let's take over the super-easy
    "  Tab to quickly jump back to our main window
    " Do this always, in case winnrs have changed
    let mainWin = bufwinnr(mainBuf)
    exe 'tnoremap <buffer> <Tab> <c-w>N:' . mainWin . 'wincmd w<cr>'
    exe 'nnoremap <buffer> <Tab> :' . mainWin . 'wincmd w<cr>'

    " always cd, just in case
    call term_sendkeys(termBufNr, "cd " . fullPath . "\<cr>")
    call term_sendkeys(termBufNr, "clear\<cr>")
    call term_sendkeys(termBufNr, "./" . fileName . "\<cr>")
endfunction
nnoremap <silent> <leader>rs :call <SID>RunCurrentInSplitTerm()<cr>
nnoremap <silent> <d-r> :call <SID>RunCurrentInSplitTerm()<cr>
