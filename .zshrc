# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/lib/android-sdk
export PATH=$PATH:/lib/android-sdk/platform-tools
export PATH=$PATH:/lib/android-sdk/tools
export PATH=$PATH:/usr/local/git/bin
export PATH=~/bin:$PATH
export NDK=/lib/android-ndk
export PATH=$PATH:$NDK

export PATH=$PATH:/usr/local/mysql/bin
export PATH=$PATH:/lib/gradle/bin
export PATH=$PATH:~/code/depot_tools
export PATH=$PATH:~/code/flutter/bin
export PATH=$PATH:~/.dotfiles/bin

export GOPATH=$HOME/code/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export NPM_PACKAGES=${HOME}/.npm-packages
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$NPM_PACKAGES/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=/Users/dhleong/.oh-my-zsh

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

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  gradle
)

source $ZSH/oh-my-zsh.sh


# ======= Settings =========================================

PROJECT_DIRS=(
    ~/git
    ~/code
    ~/code/go/src/github.com/interspace
)


# ======= Aliases ==========================================

alias dots='cd ~/.dotfiles/profile'
alias gitco='git commit -a'
alias gits='git status'
alias guts='git status'
alias gradle='./gradlew'


# ======= Vim config =======================================

bindkey -v

# faster <esc> key
export KEYTIMEOUT=1

# vim-surround emulation:
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

    file=$(fzf)
    if [ -n "$file" ]
    then
        mvim $file
    fi
}
zle -N _fzf-find-file

_fzf-find-project-dir() {
    setopt localoptions pipefail 2> /dev/null

    # list subdirs from all project dirs
    wild_dirs=( "${PROJECT_DIRS[@]/%/\/*}" )
    cmd="ls -d $wild_dirs | ag -v :"
    file=$(eval $cmd | fzf)
    if [ -n "$file" ]
    then
        # Not really sure why we can't just `cd` here...
        BUFFER="cd $file"
        zle accept-line
    fi
    zle reset-prompt
}
zle -N _fzf-find-project-dir

_git-push() {
    BUFFER="git push"
    zle accept-line
}
zle -N _git-push

# ======= Extra mappings ===================================

# ctrl-r starts searching history backward
bindkey '^r' history-incremental-search-backward

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

bindkey '^f' _fzf-find-file
bindkey '^p' _fzf-find-project-dir

# vinegar-like up directory
bindkey -M vicmd '\-' _up-directory

bindkey -M vicmd 'gp' _git-push

bindkey -M vicmd V edit-command-line
