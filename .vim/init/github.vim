
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
    let start = "ref: refs/heads/"
    let branch = fugitive#repo().head_ref()
    if branch[:len(start)-1] != start
        echo "Unexpected: " . branch[:len(start)]
        return
    endif
    let branch = branch[len(start):]
    echo system('git --no-pager push -u origin ' . branch)
endfunction
nnoremap <leader>gu :call PushNewUpstream()<CR>

"
" Github fun
"
let g:gh_cmd = "/Users/dhleong/code/hubr/gh-cmd"
function! GithubAcceptFunc()
    let ticket = expand("<cword>")
    call hubr#tag(ticket, 'accepted')
    echo "Accepted Github ticket #" . ticket
endfunction
command! GithubAccept call GithubAcceptFunc()

function! GithubTakeFunc()
    let ticket = expand("<cword>")
    call hubr#assign(ticket, hubr#me_login())
    echo "Took Github ticket #" . ticket
endfunction
command! GithubTake call GithubTakeFunc()

function! GithubOpenFunc()
    " first, are we on a Plug line?
    if dhleong#OpenPlugRepo()
        " we opened a Plug repo
        return
    endif

    let ticket = expand("<cword>")
    let repo = hubr#repo_name()
    exe ":silent !open https://github.com/" . repo . "/issues/" . ticket
endfunction
command! GithubOpen call GithubOpenFunc()

function! GithubOpenPR()
    let branch = fugitive#head()
    if branch == "master"
        echo "Don't create a PR from master..."
        return
    endif

    let repo = hubr#repo_name()
    if type(repo) == type(0)
        echo "No Github repo known"
        return
    endif

    exe ":silent !open https://github.com/" . repo . "/compare/" . branch . "?expand=1"
    echo "Opening PR request for " . branch . "..."
endfunction

" mark the issue number under the cursor as accept
nnoremap gha :GithubAccept<cr>

" 'take' the issue under the cursor (assign to 'me')
nnoremap ght :GithubTake<cr>
"
" open the issue under the cursor
nnoremap gho :GithubOpen<cr>

" awesome Unite plugin for issues
nnoremap ghi :Unite gh_issue:state=open<cr>
" nnoremap ghi :Unite gh_issue:state=open:milestone?<cr>

" open a window for creating a pull request from the current branch
nnoremap <silent> gpr :call GithubOpenPR()<cr>
