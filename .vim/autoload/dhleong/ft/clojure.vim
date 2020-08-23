
func! dhleong#ft#clojure#Jump(inNewTab)
    if fireplace#op_available('eval')
        " if connected to fireplace, prefer that
        if a:inNewTab
            exe "normal \<Plug>FireplaceDtabjump"
        else
            exe "normal \<Plug>FireplaceDjump"
        endif
        return
    endif

    " try YCM's lsp integration
    if a:inNewTab
        call dhleong#GotoInNewTab("GoTo")
    else
        exe "YcmCompleter GoTo"
    endif
endfunc
