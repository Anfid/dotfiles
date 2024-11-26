if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  startx
fi
eval "$([ -x /opt/homebrew/bin/brew ] && /opt/homebrew/bin/brew shellenv)"
