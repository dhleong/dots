func! dhleong#completer#Create()
    let requested = g:dhleong_completer
    return call('dhleong#completer#' . requested . '#Create', [])
endfunc
