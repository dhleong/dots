# ======= Aliases =========================================

alias adbrestart='adb kill-server && adb start-server && adb devices'
alias dots='cd ~/.dotfiles/dots'
alias clj-repl='(echo "(use '"'"'clojure.repl)" && cat) | clj -Sdeps '"'"'{:deps {nrepl {:mvn/version "0.6.0"}}}'"'"' -m nrepl.cmdline --port 7888 -i'
alias gitco='git commit -a'
alias gituum='git branch -vv | rg gone | awk '"'"'{print $1}'"'"' | xargs -r git branch -D'
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

