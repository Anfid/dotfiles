# Self-management
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Provides utilities, comptetions and aliases
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/pip",   from:oh-my-zsh
zplug "plugins/cargo", from:oh-my-zsh

# Reminds available aliases
zplug "djui/alias-tips"

# Fish-like suggestions as-you-type
function zsh-autosuggestions-override() {
    # ignore commands in vi-mode
    ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(forward-char end-of-line)
    ZSH_AUTOSUGGEST_USE_ASYNC=true
    ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=vi-cmd-mode
}
zplug "zsh-users/zsh-autosuggestions", hook-load:zsh-autosuggestions-override

# vi-mode plugin
MODE_CURSOR_VICMD="blinking block"
MODE_CURSOR_VIINS="blinking bar"
zplug "softmoth/zsh-vim-mode"
# viexchange messes up with syntax-highlighting. Make sure it loads after highlighting
zplug "okapia/zsh-viexchange", on:"softmoth/zsh-vim-mode", defer:3

# Substring history search
# Load after vim-mode to prevent vim bindings to perform substring search
zplug "zsh-users/zsh-history-substring-search", defer:1

# Close matching paired characters
zplug "hlissner/zsh-autopair", defer:2

# Syntax highlight
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
