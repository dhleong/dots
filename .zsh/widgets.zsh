# ======= Custom widgets ===================================

_up-directory() {
    cd ..
    zle reset-prompt
}
zle -N _up-directory

_fzf-find-file() {
    setopt localoptions pipefail 2> /dev/null

    local file=""

    # trim spaces
    local cmd=$(echo $LBUFFER | awk '{$1=$1};1')

    # we might provide special file selection for specific commands
    case $cmd in
        cd)
            file=$(list-repo-dirs | fzf)
            ;;

        judo)
            file=$(list-repo-files ~/judo | rg '.py' | fzf)
            ;;

        # default to all files in repo
        *) file=$(list-repo-files | fzf)
    esac

    local ret=$?

    # no result? stop
    [ -n "$file" ] || return

    # wrap for safety
    local file="'$file'"

    if [ -n "$LBUFFER" ]
    then
        # paste the file path into the command line
        LBUFFER="${LBUFFER}${file}"
        zle reset-prompt
        return $ret
    fi

    # with no command, we wanted to edit the file
    if [ -d /Applications/MacVim.app ]; then
        BUFFER="mvim $file"
        zle accept-line
    else
        BUFFER="$EDITOR $file"
        zle accept-line
    fi

    return $ret
}
zle -N _fzf-find-file

_fzf-find-project-dir() {
    setopt localoptions pipefail 2> /dev/null

    # list subdirs from all project dirs that exist locally
    wild_dirs=()
    for dir in $PROJECT_DIRS; do
        if [ -d $dir ]; then
            wild_dirs+=("$dir/*")
        fi
    done
    cmd="ls -d $wild_dirs | rg -v :"
    file=$(eval $cmd | fzf)

    if [ -n "$file" ]
    then
        # Not really sure why we can't just `cd` here...
        BUFFER="cd '$file'"
        zle accept-line
    fi
    zle reset-prompt
}
zle -N _fzf-find-project-dir

# CTRL-R - Paste the selected command from history into the command line
_fzf-history-widget() {
    local selected num
    setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
    selected=( $(fc -rl 1 |\
        # distinct-ify commands:
        sort -t ' ' -ruk4 |\
        # re-sort by newest-first
        sort -t ' ' -rnk1 |\
        FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-60%} $FZF_DEFAULT_OPTS --nth=2..,.. --tiebreak=index --preview='echo {} | sed \"s/^[ 0-9]*//\"' --preview-window=down:5:wrap --bind=ctrl-r:toggle-sort --expect=tab $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" fzf) )
    local ret=$?
    if [ -n "$selected" ]; then
        # accept (execute) the line by default
        local accept=1
        if [[ $selected[1] = tab ]]; then
            # if we hit tab (see --expect=tab above) then allow editing
            accept=0
            shift selected
        fi

        num=$selected[1]
        if [ -n "$num" ]; then
            zle vi-fetch-history -n $num
            if [ $accept -eq 1 ]; then
                # accept!
                zle accept-line
            else
                # switch to normal mode at the start of line
                zle beginning-of-line
                zle vi-cmd-mode
            fi
        fi
    fi
    zle reset-prompt
    return $ret
}
zle -N _fzf-history-widget

_git-fzf-branch() {
    setopt localoptions pipefail 2> /dev/null

    # list subdirs from all project dirs
    cmd='git branch -a | rg -v -F \* | ~/.dotfiles/dots/bin/filter-branches'
    branches=$(eval $cmd)
    if [ -z "$branches" ]; then
        echo "\nYou're on the only branch"
        zle reset-prompt
        return
    fi

    branch=$(echo $branches | fzf)
    if [ -n "$branch" ]; then
        # if we selected a remote branch, ensure that we don't check it out
        # in a detached state
        branch=$(echo $branch | sed 's/remotes\/[^/]*\///')

        if [ -n "$LBUFFER" ]; then
            # paste the branch into the command line
            LBUFFER="${LBUFFER} ${branch}"
        else
            # no existing line, just select directly
            BUFFER="git co $branch"
            zle accept-line
        fi
    fi
    zle reset-prompt
}
zle -N _git-fzf-branch

_git-commit() {
    BUFFER="gitco"
    zle accept-line
}
zle -N _git-commit

_git-diff() {
    BUFFER="git diff"
    zle accept-line
}
zle -N _git-diff

_git-pull-prune() {
    BUFFER="git pull --prune && gituum"
    zle accept-line
}
zle -N _git-pull-prune

_git-push() {
    BUFFER="git push"
    zle accept-line
}
zle -N _git-push

_git-push-upstream() {
    branchName=$(git branch | grep \* | cut -d ' ' -f2)

    BUFFER="git push -u origin $branchName"
    zle accept-line
}
zle -N _git-push-upstream

_git-status() {
    BUFFER="gits"
    zle accept-line
}
zle -N _git-status
