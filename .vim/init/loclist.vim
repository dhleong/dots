
" ======= Better loclist/error navigation ==================

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

