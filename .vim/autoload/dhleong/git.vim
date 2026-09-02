func! s:parentBranchIsh()
    " NOTE: if on the default branch, this may return "some" previous branch

    " NOTE: we deliberately *don't* use `git show-branch` here: it refuses to
    " look at more than 26 refs and silently drops the rest, and once the
    " default branch is one of the dropped ones it cheerfully reports some
    " entirely unrelated branch as the parent.
    let defaultBranch = dhleong#git#DefaultBranch()

    " %(ahead-behind:HEAD) gives us "<ahead> <behind>" per branch, where
    " <behind> counts the commits HEAD has that the branch doesn't -- ie
    " exactly the distance from our fork point to HEAD. Nearest fork point
    " wins. Anything that *contains* HEAD (our own branch, or a branch stacked
    " on top of us) has <behind> == 0, so it drops out without a special case.
    let nearest = ''
    let nearestDistance = -1
    for line in systemlist('git for-each-ref refs/heads '
                \.'--format="%(ahead-behind:HEAD) %(refname:short)" 2>/dev/null')
        let parts = split(trim(line))
        if len(parts) < 3
            continue
        endif

        let distance = str2nr(parts[1])
        let branch = parts[2]
        if distance <= 0
            " this branch contains HEAD, so it can't be our parent
            continue
        endif

        " on a tie prefer the default branch, so that eg a stale branch parked
        " on the same commit doesn't win
        if nearestDistance < 0 || distance < nearestDistance
                    \ || (distance == nearestDistance && branch ==# defaultBranch)
            let nearestDistance = distance
            let nearest = branch
        endif
    endfor

    return nearest
endfunc

func! dhleong#git#CurrentBranch()
    return trim(system('git branch --show-current'))
endfunc

func! dhleong#git#DefaultBranch()
    " based on: https://stackoverflow.com/a/44750379
    return trim(system('git symbolic-ref refs/remotes/origin/HEAD '
                    \."| sed 's@^refs/remotes/origin/@@'"))
endfunc

func! dhleong#git#HashOf(obj)
    return trim(system('git rev-parse ' . a:obj))
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
    if rawParent ==# '' || rawParent ==# defaultBranch
        return ''
    endif

    if dhleong#git#HashOf(rawParent) ==# dhleong#git#HashOf(defaultBranch)
        " IE: there's an "empty" branch aligned with main
        return ''
    endif

    return rawParent
endfunc
