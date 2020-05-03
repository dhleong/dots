# ======= Vim shell mode setup ============================

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


# ======= Vim term interactions ===========================

# if we're in a vim terminal, send input commands to
# Vim so our <d-r> mapping can potentially make use of it
notify_vim_term() {
    echo -n '\e]51;["call", "Tapi_dhl_onTerm", "'$1'"]\07'
}

if ! [ -z "$VIM_TERMINAL" ]
then
    autoload -U add-zsh-hook

    add-zsh-hook preexec notify_vim_term
fi
