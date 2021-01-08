" TODO: extract some of this into a plugin, probably
" ======= state ===========================================

if !exists("s:openTerms")
    let s:openTerms = {}
endif

" ======= util ============================================

" xcode discovery + communication {{{

func! s:xcodeConfig()
    let path = dhleong#ft#swift#FindProj()
    if path !=# ''
        return '-project ' . path
    endif

    return ''
endfunc

func! s:xcodebuild(args)
    let config = s:xcodeConfig()
    if config ==# ''
        return ''
    endif
    return 'xcodebuild ' . config . ' ' . a:args
endfunc

func! s:xcodejson(args)
    let cmd = s:xcodebuild(a:args)
    if cmd ==# ''
        return v:null
    endif

    let output = system(cmd . ' -json')
    return json_decode(output)
endfunc

" }}}

func! s:ensureScheme() " {{{
    if get(b:, 'swift_xcode_scheme', '') ==# ''
        echo "Locating project..."

        " TODO: we probably ought to refactor this to be done async
        let info = s:xcodejson('-list')
        if type(info) != v:t_dict
            echom "Couldn't locate xcode config"
            return
        endif

        if has_key(info.project, 'schemes') && len(info.project.schemes)
            let b:swift_xcode_scheme = info.project.schemes[0]
            return b:swift_xcode_scheme
        endif
    endif

    let scheme = get(b:, 'swift_xcode_scheme', '')
    if scheme ==# ''
        echom "No scheme found"
        return
    endif

    return scheme
endfunc " }}}

func! s:onRunComplete(termWinNr, job, status) " {{{
    let term = s:openTerms[a:termWinNr]
    let win = bufwinnr(term.bufnr)
    if win == -1
        " nop?
        return
    endif

    if a:status == 0
        " successful run; close the window
        exe win . 'wincmd q'
    else
        " keep the window open (and focus!) something went wrong
        let current = winnr()
        exe win . 'wincmd w'
        resize +5
        exe current . 'wincmd w'
    endif
endfunc " }}}

func! s:Run() " {{{
    let scheme = s:ensureScheme()
    if scheme ==# ''
        return
    endif

    " ensure any previous job is stopped
    for term in values(s:openTerms)
        let win = bufwinnr(term.bufnr)
        if win != -1
            call job_stop(term.job)
            exe win . 'wincmd q'
        endif
    endfor

    let win = winnr()

    " make sure we're up to date
    if &modified
        write
    endif

    " TODO: open in float?
    let winSize = 7
    exe 'botright split | resize ' . winSize
    let termWinNr = winnr()

    let termBufNr = term_start(s:xcodebuild('-scheme ' . scheme), {
        \ 'term_name': 'Xcode Build',
        \ 'curwin': 1,
        \ 'exit_cb': function('s:onRunComplete', [termWinNr]),
        \ })

    let job = term_getjob(termBufNr)
    let s:openTerms[termWinNr] = {
        \ 'bufnr': termBufNr,
        \ 'job': job,
        \ }

    if win != 0
        " go back to the previous window
        exe win . 'wincmd w'
    endif
endfunc " }}}


" ======= mappings ========================================

" my standard mappings
nnoremap <buffer> <c-w>gd :call dhleong#GotoInNewTab("GoToDefinition")<cr>
nnoremap <buffer> gd :YcmCompleter GoToDefinition<cr>
nnoremap <buffer> K :YcmCompleter GetHover<cr>
nnoremap <buffer> <leader>js :YcmCompleter GoToReferences<cr>

" swift/xcode-specific
nnoremap <silent> <leader>pr :call <SID>Run()<cr>

" ======= init ============================================

call dhleong#ft#swift#init()
