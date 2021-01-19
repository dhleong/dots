# zsh environment vars configured here, since apparently
# .zshrc isn't loaded for script commands in VIM, etc.
# see: https://stackoverflow.com/a/18570967

macvimPath=/Applications/MacVim.app/Contents/MacOS/Vim
if [ -f $macvimPath ]
then
    export EDITOR="$macvimPath"
    alias vim="$macvimPath"
else
    export EDITOR=vim
fi

export PATH=$PATH:~/lib/android-sdk
export PATH=$PATH:~/lib/android-sdk/platform-tools
export PATH=$PATH:~/lib/android-sdk/tools
export PATH=$PATH:/usr/local/git/bin
export PATH=~/bin:$PATH
export NDK=~/lib/android-ndk
export PATH=$PATH:$NDK

export PATH=$PATH:/usr/local/mysql/bin
export PATH=$PATH:/lib/gradle/bin
export PATH=$PATH:~/code/depot_tools
export PATH=$PATH:~/code/flutter/bin
export PATH=$PATH:~/.dotfiles/bin

export GOPATH=$HOME/code/go
export GOBIN=$GOPATH/bin
export GO111MODULE="auto"
export PATH=$PATH:$GOBIN

export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export NPM_PACKAGES=${HOME}/.npm-packages
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$NPM_PACKAGES/bin:$PATH"

export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"

export PATH=$PATH:$HOME/.cargo/bin

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

export ANDROID_HOME=~/lib/android-sdk
export ANDROID_NDK=$NDK

if [ -f "$HOME/.zshenv.local" ]
then
    source $HOME/.zshenv.local
fi

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

export GRAALVM_VERSION="19.3.1"
export GRAALVM_HOME="/Library/Java/JavaVirtualMachines/graalvm-ce-java8-${GRAALVM_VERSION}/Contents/Home"
if [ -d $GRAALVM_HOME ]; then
    export PATH="$PATH:$GRAALVM_HOME/bin"
fi

# Checking for fastlane updates is unnecessarily slow and noisy
export FASTLANE_SKIP_UPDATE_CHECK=1

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
