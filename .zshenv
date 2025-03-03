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

if [ -f "$HOME/lib/android-sdk" ]; then
    export ANDROID_HOME=~/lib/android-sdk
else
    export ANDROID_HOME=$HOME/Library/Android/sdk
fi
if [ -f "$HOME/lib/android-ndk" ]; then
    export ANDROID_NDK=~/lib/android-ndk
fi

# Borrowed from: https://unix.stackexchange.com/a/480523
+path.append() { # {{{
    # For each passed dirname...
    local dirname
    for   dirname; do
        # Strip the trailing directory separator if any from this dirname,
        # reducing this dirname to the canonical form expected by the
        # test for uniqueness performed below.
        dirname="${dirname%/}"

        # If this dirname is either relative, duplicate, or nonextant, then
        # silently ignore this dirname and continue to the next. Note that the
        # extancy test is the least performant test and hence deferred.
        [[ "${dirname:0:1}" == '/' &&
           ":${PATH}:" != *":${dirname}:"* &&
           -d "${dirname}" ]] || continue

        # Else, this is an existing absolute unique dirname. In this case,
        # append this dirname to the current ${PATH}.
        PATH="${PATH}:${dirname}"
    done

    # Strip an erroneously leading delimiter from the current ${PATH} if any,
    # a common edge case when the initial ${PATH} is the empty string.
    PATH="${PATH#:}"

    # Export the current ${PATH} to subprocesses. Although system-wide scripts
    # already export the ${PATH} by default on most systems, "Bother free is
    # the way to be."
    export PATH
} # }}}

+path.append $ANDROID_HOME $ANDROID_HOME/platform-tools $ANDROID_HOME/tools
+path.append $ANDROID_NDK
+path.append /usr/local/git/bin
+path.append ~/bin

+path.append /usr/local/mysql/bin /lib/gradle/bin
+path.append ~/code/depot_tools ~/code/flutter/bin
+path.append ~/.dotfiles/bin ~/.local/bin

export GOPATH=$HOME/code/go
export GOBIN=$GOPATH/bin
export GO111MODULE="auto"
+path.append $GOBIN

export NPM_PACKAGES=${HOME}/.npm-packages
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
# export PATH="/usr/local/bin:$PATH"
# export PATH="$NPM_PACKAGES/bin:$PATH"
+path.append /usr/local/bin
+path.append $NPM_PACKAGES

# export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
+path.append /usr/local/opt/postgresql@9.6/bin

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
+path.append "$GRAALVM_HOME/bin"

+path.append "$HOME/.local/share/nvim/lazy/fzf/bin"

if [ -d "$HOME/.zshenv.local" ]
then
    for file in $HOME/.zshenv.local/*; do
        source "$file"
    done
elif [ -f "$HOME/.zshenv.local" ]
then
    source $HOME/.zshenv.local
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Checking for fastlane updates is unnecessarily slow and noisy
export FASTLANE_SKIP_UPDATE_CHECK=1

# enable persistent history in elixir/erlang shells
export ERL_AFLAGS="-kernel shell_history enabled"

export RIPGREP_CONFIG_PATH="$HOME/.config/rg"
