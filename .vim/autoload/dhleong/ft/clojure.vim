
func! dhleong#ft#clojure#Jump(inNewTab)
    try
        " if connected to fireplace, prefer that
        if a:inNewTab
            exe "normal \<Plug>FireplaceDtabjump"
        else
            exe "normal \<Plug>FireplaceDjump"
        endif
        return
    catch /Fireplace:.*REPL/
        " not connected to fireplace REPL...
    endtry

    " ... try YCM's lsp integration
    if a:inNewTab
        call dhleong#GotoInNewTab("GoTo")
    else
        exe "YcmCompleter GoTo"
    endif
endfunc
