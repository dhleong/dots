# zsh environment vars configured here, since apparently
# .zshrc isn't loaded for script commands in VIM, etc.
# see: https://stackoverflow.com/a/18570967

macvimPath=/Applications/MacVim.app/Contents/MacOS/Vim
if [ -f $macvimPath ]
then
    export EDITOR="$macvimPath"
    alias vim="$macvimPath"
elif which nvim > /dev/null 2>&1
then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

# Don't re-add values to the PATH when loaded from tmux
if [ -z "$TMUX" ]; then
    export PATH=$PATH:$ANDROID_HOME
    export PATH=$PATH:$ANDROID_HOME/platform-tools
    export PATH=$PATH:$ANDROID_HOME/tools
    export PATH=$PATH:/usr/local/git/bin
    export PATH=~/bin:$PATH
    export NDK=$ANDROID_NDK
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

    # A bit hacky: On some machines I use, .cargo/env is initialized in a system-wide
    # zprofile. In order to let zprofile order things as it prefers, we skip initializing
    # it here in that case.
    if ! [ -f "/etc/zsh/zprofile" ]; then
        if [ -f "$HOME/.cargo/env" ]; then
            source "$HOME/.cargo/env"
        fi
    fi

    export GRAALVM_VERSION="19.3.1"
    export GRAALVM_HOME="/Library/Java/JavaVirtualMachines/graalvm-ce-java8-${GRAALVM_VERSION}/Contents/Home"
    if [ -d $GRAALVM_HOME ]; then
        export PATH="$PATH:$GRAALVM_HOME/bin"
    fi

    if [ -f "$HOME/.zshenv.local" ]
    then
        source $HOME/.zshenv.local
    fi
fi

if [ -f "$HOME/lib/android-sdk" ]; then
    export ANDROID_HOME=~/lib/android-sdk
else
    export ANDROID_HOME=$HOME/Library/Android/sdk
fi
if [ -f "$HOME/lib/android-ndk" ]; then
    export ANDROID_NDK=~/lib/android-ndk
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Checking for fastlane updates is unnecessarily slow and noisy
export FASTLANE_SKIP_UPDATE_CHECK=1

# enable persistent history in elixir/erlang shells
export ERL_AFLAGS="-kernel shell_history enabled"

export RIPGREP_CONFIG_PATH="$HOME/.config/rg"
