
function s:ClearEcho(msg)
    echon "\r\r"
    echon a:msg

    " make extra sure we empty the echo buffer, in case
    " there's output from ALE
    redraw!
endfunction

function s:TryFixAle()
    " NOTE: ! flag to not complain when there are no ale fixers
    call ale#fix#Fix(bufnr(''), '!')
endfunction

function! dhleong#fix#Fix()
    if !dhleong#completer().HasQuickFixes()
        " no completer options; clear error output from above
        call s:ClearEcho('')

        call s:TryFixAle()
        return
    endif

    let before = changenr()

    call dhleong#completer().PerformQuickFix()

    let afterCompleter = changenr()
    if afterCompleter == before
        " YCM's default message would be nice if we weren't about
        " to also try ALE...
        call s:ClearEcho('Completer found nothing to fix...')
    endif

    call s:TryFixAle()
endfunction
