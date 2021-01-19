
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
NPM_PACKAGES=${HOME}/.npm-packages
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
PATH="/usr/local/bin:$PATH"
PATH="$NPM_PACKAGES/bin:$PATH"

macvimPath=/Applications/MacVim.app/Contents/MacOS/Vim
if ! [ -f $macvimPath ] && [ -t 1 ]; then
    # also, disable the "pause sending" tty feature so we can use ctrl-s in cli vim
    stty stop ''

    # manually switch to zsh on windows bash
    exec zsh
fi

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi
