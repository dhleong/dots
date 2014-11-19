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
    export JAVA_HOME=$(/usr/libexec/java_home)
fi

export ANDROID_HOME=/lib/android-sdk
export PROGUARD_HOME=$ANDROID_HOME/tools/proguard

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

alias vim="/Applications/MacVim.app/Contents/MacOS/Vim"

alias upgradle=". ~/bin/_upgradle"

test -r /sw/bin/init.sh && . /sw/bin/init.sh

# make sure this is always done
set complete='enhance' 

# vim input mode! Crazy!
set -o vi 

##
# Your previous /Users/dhleong/.bash_profile file was backed up as /Users/dhleong/.bash_profile.macports-saved_2011-06-27_at_18:30:37
##

# MacPorts Installer addition on 2011-06-27_at_18:30:37: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

# enable bash_completion
if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

# git completion; use the following to add the file:
# curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
