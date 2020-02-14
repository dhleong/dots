
# google cloud
if [ -d $HOME/code/google-cloud-sdk/ ]; then
    source $HOME/code/google-cloud-sdk/path.zsh.inc
    source $HOME/code/google-cloud-sdk/completion.zsh.inc
fi

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="cloud"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# load zsh-completions from homebrew
fpath=(/usr/local/share/zsh-completions $fpath)
fpath=(/usr/local/share/zsh/site-functions $fpath)

# git-completion.zsh:
fpath=(~/.zsh $fpath)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  # git
  gradle

  # https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
  zsh-syntax-highlighting
)

# NOTE: See .zshenv for zsh path config

source $ZSH/oh-my-zsh.sh

if [ -f ~/.iterm2_shell_integration.zsh ]; then
    source ~/.iterm2_shell_integration.zsh
fi


# ======= Settings =========================================

PROJECT_DIRS=(
    ~/git
    ~/code
    ~/code/go/src/github.com/interspace
    ~/code/go/src/github.com/dhleong
    ~/judo
)

# AUTO_PARAM_SLASH="true"
setopt AUTO_PARAM_SLASH

# ======= Aliases ==========================================

alias adbrestart='adb kill-server && adb start-server && adb devices'
alias dots='cd ~/.dotfiles/dots'
alias clj-repl='(echo "(use '"'"'clojure.repl)" && cat) | clj -Sdeps '"'"'{:deps {nrepl {:mvn/version "0.6.0"}}}'"'"' -m nrepl.cmdline --port 7888 -i'
alias gitco='git commit -a'
alias gituum='git branch -vv | ag gone | awk '"'"'{print $1}'"'"' | xargs git branch -D'
alias gits='git status'
alias guts='git status'
alias gpp='git pull --prune'
alias gradle='./gradlew'

macvimPath=/Applications/MacVim.app/Contents/MacOS/Vim
if [ -f $macvimPath ]
then
    export EDITOR="$macvimPath"
    alias vim="$macvimPath"
else
    export EDITOR=vim
fi

# ======= Vim config =======================================

bindkey -v

# faster <esc> key
export KEYTIMEOUT=1

# vim-surround emulation:
# NOTE: zsh-syntax-highlighting currently breaks these :(
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround

# vim inner/outer text objects
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
    for c in {a,i}{\',\",\`}; do
        bindkey -M $m $c select-quoted
    done
done


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
        judo)
            file=$(list-repo-files ~/judo | ag '.py' | fzf)
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
    cmd="ls -d $wild_dirs | ag -v :"
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
    selected=( $(fc -rl 1 |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --preview='echo {} | sed \"s/^[ 0-9]*//\"' --preview-window=down:5:wrap --bind=ctrl-r:toggle-sort --expect=tab $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" fzf) )
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
    cmd='git branch -a | ag -v -Q \* | ~/.dotfiles/dots/bin/filter-branches'
    branches=$(eval $cmd)
    if [ -z "$branches" ]
    then
        echo "\nYou're on the only branch"
        zle reset-prompt
        return
    fi

    branch=$(echo $branches | fzf)
    if [ -n "$branch" ]
    then
        # if we selected a remote branch, ensure that we don't check it out
        # in a detached state
        branch=$(echo $branch | sed 's/remotes\/[^/]*\///')

        BUFFER="git co $branch"
        zle accept-line
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

# ======= Extra mappings ===================================

# ctrl-r starts searching history backward
bindkey '^r' _fzf-history-widget

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

bindkey '^f' _fzf-find-file
bindkey '^p' _fzf-find-project-dir

# vinegar-like up directory
bindkey -M vicmd '\-' _up-directory

# git mappings
bindkey -M vicmd 'gb' _git-fzf-branch
bindkey -M vicmd 'gc' _git-commit
bindkey -M vicmd 'gd' _git-diff
bindkey -M vicmd 'gl' _git-pull-prune
bindkey -M vicmd 'gp' _git-push
bindkey -M vicmd 'gu' _git-push-upstream
bindkey -M vicmd 'gs' _git-status

bindkey -M vicmd V edit-command-line


# ======= Vim term interactions ===========================

# if we're in a vim terminal, send input commands to
# Vim so our <d-r> mapping can potentially make use of it
notify_vim_term() {
    echo -n '\e]51;["call", "Tapi_dhl_onTerm", "'$1'"]\07'
}

if ! [ -z "$VIM_TERMINAL" ]
then
    autoload -U add-zsh-hook

    add-zsh-hook preexec notify_vim_term
fi
