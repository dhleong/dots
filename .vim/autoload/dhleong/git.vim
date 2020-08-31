func! s:parentBranchIsh()
    " NOTE: if on the default branch, this may return "some" previous branch

    " based on: https://stackoverflow.com/a/17843908
    return system('git show-branch '
                \.'| sed "s/].*//" '
                \.'| grep "\*" '
                \.'| grep -v "$(git rev-parse --abbrev-ref HEAD)"'
                \.'| head -n1 '
                \.'| sed "s/^.*\[//"')
endfunc

func! dhleong#git#CurrentBranch()
    return system('git branch --show-current')
endfunc

func! dhleong#git#DefaultBranch()
    " based on: https://stackoverflow.com/a/44750379
    return system('git symbolic-ref refs/remotes/origin/HEAD '
                \."| sed 's@^refs/remotes/origin/@@'")
endfunc

func! dhleong#git#ParentBranch()
    " NOTE: if we're not currently on the default branch, returns the "parent"
    " branch for the current git ref. If on the default branch, or the
    " "parent" branch is itself the default branch, returns an empty string

    let currentBranch = dhleong#git#CurrentBranch()
    let defaultBranch = dhleong#git#DefaultBranch()
    if currentBranch == defaultBranch
        " when on the default branch, we necessarily have no parent
        return ''
    endif

    let rawParent = s:parentBranchIsh()
    if rawParent == defaultBranch
        return ''
    endif

    return rawParent
endfunc
