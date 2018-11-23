# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
bindkey "" up-line-or-beginning-search

# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi
bindkey "" down-line-or-beginning-search

if [[ "${terminfo[kcbt]}" != "" ]]; then
  bindkey "${terminfo[kcbt]}" reverse-menu-complete   # [Shift-Tab] - move through the completion menu backwards
fi

# VI-mode remaps
# normal mode
bindkey -M vicmd "H" vi-first-non-blank
bindkey -M vicmd "L" vi-end-of-line
bindkey -M vicmd "s" vi-backward-word
bindkey -M vicmd "S" vi-backward-blank-word
bindkey -M vicmd "*" history-substring-search-up
bindkey -M vicmd "#" history-substring-search-down
bindkey -M vicmd "b" history-substring-search-up
bindkey -M vicmd "B" history-substring-search-down
