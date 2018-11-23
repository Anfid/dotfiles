# Self-management
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Git utils
zplug "plugins/git",   from:oh-my-zsh

# Completions
zplug "plugins/pip",   lazy:true, from:oh-my-zsh
zplug "plugins/cargo", lazy:true, from:oh-my-zsh
zplug "zpm-zsh/ssh",   lazy:true

# Fish-like suggestions as-you-type
zplug "zsh-users/zsh-autosuggestions"

# vi-mode plugin
MODE_CURSOR_VICMD="blinking block"
MODE_CURSOR_VIINS="blinking bar"
zplug "softmoth/zsh-vim-mode"
# viexchange messes up with syntax-highlighting. Make sure it loads after highlighting
zplug "okapia/zsh-viexchange", on:"softmoth/zsh-vim-mode", defer:3

# Close matching paired characters
zplug "hlissner/zsh-autopair", defer:2

# Substring history search
# Load after vim-mode to prevent vim bindings to substring search
zplug "zsh-users/zsh-history-substring-search", lazy:true, defer:1

# syntax highlight
zplug "zdharma/fast-syntax-highlighting", defer:2

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load
