
function! dhleong#fix#Fix()
    " first, try ALE
    call ale#fix#Fix(bufnr(''), '')

    " The result from ale#fix#Fix just means whether or not
    " it *tried* to fix something, but gives no indication
    " whether or not there was something it *could* fix.
    " So, just always also try Ycm

    let ycmCommands = youcompleteme#SubCommandsComplete('','', 0)
    if ycmCommands == ''
        " no completer options; clear error output from above
        echon "\r\r"
        echon ''
        return
    endif

    if match(ycmCommands, 'FixIt') != -1
        " FixIt supported!
        YcmCompleter FixIt
    endif

endfunction
