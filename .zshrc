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
ZSH_CUSTOM=$HOME/.zsh/

# load zsh-completions from homebrew
fpath=(/usr/local/share/zsh-completions $fpath)
fpath=(/usr/local/share/zsh/site-functions $fpath)

# git-completion.zsh:
fpath=(~/.zsh/bin $fpath)

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
    ~/work
)

setopt AUTO_PARAM_SLASH


# ======= Extra mappings ===================================
# NOTE: it seems these need to live here; the widgets
# they're bound to live in .zsh/mappings.zsh

# ctrl-r starts searching history backward
bindkey '^r' _fzf-history-widget

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

bindkey '^f' _fzf-find-file
bindkey '^p' _fzf-find-project-dir
bindkey '^b' _git-fzf-branch

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

if [ -f "$HOME/.zshrc.local" ]
then
    source $HOME/.zshrc.local
fi

source /Users/daniel.leong/.nix-profile/etc/profile.d/nix.sh
