export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
export CLICOLOR=1
#export LSCOLORS=ExFxCxDxBxegedabagacad
export LSCOLORS=GxFxCxDxBxegedabagaced
PATH=$PATH:/lib/android-sdk
PATH=$PATH:/lib/android-sdk/platform-tools
PATH=$PATH:/lib/android-sdk/tools
PATH=$PATH:/usr/local/git/bin
PATH=~/bin:$PATH
NDK=/lib/android-ndk
PATH=$PATH:$NDK

PATH=$PATH:/usr/local/mysql/bin
PATH=$PATH:/lib/gradle/bin
PATH=$PATH:~/code/depot_tools
PATH=$PATH:~/.dotfiles/bin

pip() {
    if [ "$1" = "install" -o "$1" = "bundle" ]; then
        cmd="$1"
        shift
        /usr/local/bin/pip $cmd --user $@
    else
        /usr/local/bin/pip $@
    fi
}

upgradle() {
    # Simple command to cd to the parent directory containing the
    #  "nearest" build.gradle

    start=$(pwd)

    while true
    do
        # always go up first
        cd ..

        # is there a build.gradle?
        if $(ls build.gradle > /dev/null 2> /dev/null)
        then
            # let me know where I am
            pwd
            break
        fi

        if [ $(pwd) = $HOME ]
        then
            cd $start
            echo "Couldn't find a build.gradle file above this directory"
            break
        fi
    done
}

if [ -z "$JAVA_HOME" ]
then
    # export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
    # export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
    # export JAVA6_HOME=$(/usr/libexec/java_home -v 1.6)
    export JAVA7_HOME=$(/usr/libexec/java_home -v 1.7)
    export JAVA8_HOME=$(/usr/libexec/java_home -v 1.8)
fi

export ANDROID_HOME=/lib/android-sdk
export ANDROID_NDK=$NDK
export PROGUARD_HOME=$ANDROID_HOME/tools/proguard
export GOPATH=$HOME/code/go
export GOBIN=$GOPATH/bin
# export LEIN_JAVA_CMD=/usr/local/bin/drip

export HOMEBREW_GITHUB_API_TOKEN=08cec7f5967f472ededdb39dc031898a648b6155

alias aj='ag --java'
alias airportcycle='networksetup -setairportpower airport off; networksetup -setairportpower airport on'
alias dots='cd ~/.dotfiles/profile'
alias dynamodb='cd ~/dynamodb; java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar'
alias l='ls -al'
alias seriestracker='(cd ~/SeriesTracker-v6/; java -jar seriestracker.jar)'
alias gits='git status'
alias guts='git status'
alias gitco='git commit -a'
alias gitpp='git pull && git push'
alias gituum='git branch -vv | ag gone | awk '"'"'{print $1}'"'"' | xargs git branch -D'
alias gitvacuum='gituum'
alias gradle='./gradlew'
alias up='cd ..'
alias www='python -m SimpleHTTPServer'
alias thundercats='./gradlew'
alias autobots='./gradlew --offline'
alias rollout='~/git/autobots/rollout'

alias antgo='ant debug install && sh run.sh'
alias adbrestart='adb kill-server && adb start-server && adb devices'
alias sloccount=cloc

alias vim="/Applications/MacVim.app/Contents/MacOS/Vim"

# make sure this is always done
set complete='enhance'

# vim input mode! Crazy!
set -o vi 

# enable bash_completion (brew install bash-completion)
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

# git completion; use the following to add the file:
# curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# config for fzf (ag will ignore the right files)
export FZF_DEFAULT_COMMAND='ag -l -g ""'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

mfe() {
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && mvim "$file"
}

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

if [ -n "$(which aws_completer)" ]; then
    complete -C aws_completer aws
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

eval $(/usr/libexec/path_helper -s)
source ~/.bashrc
