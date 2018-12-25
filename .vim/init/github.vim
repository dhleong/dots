
" better diffs with fugitive
set diffopt=filler,vertical

" mappings
nnoremap <leader>gc :Gcommit -a<CR>
nnoremap <leader>ga :Gcommit -a --amend<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR><c-w>=
nnoremap <leader>gb :Gblame<CR>

nnoremap <leader>gk :term git push heroku<cr>

function! WriteAndPush()
    if expand('%') == "COMMIT_EDITMSG" || expand('%:h') == "COMMIT_EDITMSG"
        :Gwrite
        " :Git push
        !git --no-pager push
    else
        " :Git push
        !git --no-pager push
    endif
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
    exe ":silent !open " . repo . "/issues/" . ticket
endfunction
command! GithubOpen call GithubOpenFunc()

function! GithubOpenPR()
    let branch = FugitiveHead()
    if branch == ''
        echo "Not on a branch"
        return
    elseif branch == "master"
        echo "Don't create a PR from master..."
        return
    endif

    let repo = lilium#gh().repoUrl()
    if type(repo) == type(0)
        echo "No Github repo known"
        return
    endif

    exe ":silent !open '" . repo . "/compare/" . branch . "?expand=1'"
    echo "Opening PR request for " . branch . "..."
endfunction

" open the issue under the cursor
nnoremap gho :GithubOpen<cr>

" open a window for creating a pull request from the current branch
nnoremap <silent> gpr :call GithubOpenPR()<cr>
