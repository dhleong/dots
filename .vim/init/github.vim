
" better diffs with fugitive
set diffopt=filler,vertical

" mappings
nnoremap <leader>gc :Gcommit -a<CR>
nnoremap <leader>ga :Gcommit -a --amend<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiffsplit!<CR><c-w>=
nnoremap <leader>gb :Gblame<CR>

nnoremap <leader>gk :term git push heroku<cr>

function! WriteAndPush()
    if expand('%') == "COMMIT_EDITMSG" || expand('%:h') == "COMMIT_EDITMSG"
        " NOTE: Gwrite seems to be broken here for some reason...
        norm ZZ
    endif

    " :Git push
    !git --no-pager push
endfunction
nnoremap <leader>gp :call WriteAndPush()<CR>

function! PushNewUpstream()
    let branch = FugitiveHead()
    if branch == ''
        echo "Not on a branch"
        return
    endif
    echo system('git --no-pager push -u origin ' . branch)
endfunction
nnoremap <leader>gu :call PushNewUpstream()<CR>

"
" Github fun
"

function! GithubOpenFunc()
    " first, are we on a Plug line?
    if dhleong#OpenPlugRepo()
        " we opened a Plug repo
        return
    endif

    let ticket = expand("<cword>")
    let repo = lilium#gh().repoUrl()
    if repo == ''
        echo "No Github repo found"
        return
    endif
    exe ":silent !open " . repo . "/issues/" . ticket
endfunction
command! GithubOpen call GithubOpenFunc()

function! s:urlencode(str)
    " this is not nearly complete, but it's sufficient for now...
    return substitute(a:str, '#', '%23', 'g')
endfunction

" open the issue under the cursor
nnoremap gho :GithubOpen<cr>

func! s:openGithubPrCreator()
    let args = []

    " if this is a branch against eg a staging branch, specify the
    " base branch automatically:
    let parentBranch = dhleong#git#ParentBranch()
    if parentBranch !=# ''
        call extend(args, ['--base', parentBranch])
    endif

    " exe 'term gh pr create' . args
    call lilium#pr#Create(args)
endfunc

" open a window for creating a pull request from the current branch
nnoremap <silent> gpr :call <SID>openGithubPrCreator()<cr>
