# Self-management
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Git utils
zplug "plugins/git",   from:oh-my-zsh

# Completions
zplug "plugins/pip",   from:oh-my-zsh
zplug "plugins/cargo", from:oh-my-zsh
zplug "zpm-zsh/ssh"

# Fish-like suggestions as-you-type
zplug "zsh-users/zsh-autosuggestions"

# syntax highlight
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load
