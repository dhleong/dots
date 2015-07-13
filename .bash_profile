export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
export CLICOLOR=1
#export LSCOLORS=ExFxCxDxBxegedabagacad
export LSCOLORS=GxFxCxDxBxegedabagaced
PATH=$PATH:/lib/android-sdk
PATH=$PATH:/lib/android-sdk/platform-tools
PATH=$PATH:/lib/android-sdk/tools
PATH=$PATH:/usr/local/git/bin
PATH=~/bin:$PATH
NDK=/lib/android-ndk-r7c/

PATH=$PATH:/usr/local/mysql/bin
PATH=$PATH:/lib/gradle/bin

if [ -z "$JAVA_HOME" ]
then
    # export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
    # export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
    export JAVA6_HOME=$(/usr/libexec/java_home -v 1.6)
    export JAVA7_HOME=$(/usr/libexec/java_home -v 1.7)
    export JAVA8_HOME=$(/usr/libexec/java_home -v 1.8)
fi

export ANDROID_HOME=/lib/android-sdk
export PROGUARD_HOME=$ANDROID_HOME/tools/proguard

alias aj='ag --java'
alias airportcycle='networksetup -setairportpower airport off; networksetup -setairportpower airport on'
alias l='ls -al'
alias seriestracker='(cd ~/SeriesTracker-v6/; java -jar seriestracker.jar)'
alias gits='git status'
alias guts='git status'
alias gitco='git commit -a'
alias gitpp='git pull && git push'
alias up='cd ..'
alias thundercats='./gradlew'
alias autobots='./gradlew --offline'

alias antgo='ant debug install && sh run.sh'
alias adbrestart='adb kill-server && adb start-server && adb devices'
alias sloccount=cloc

alias vim="/Applications/MacVim.app/Contents/MacOS/Vim"

alias upgradle=". ~/bin/_upgradle"

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
. ~/.bashrc

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

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
