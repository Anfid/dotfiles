export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$HOME/.config/zsh"

if [[ -d "$HOME/.local/bin" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -f "/Users/anfid/.ghcup/env" ]; then
  source "/Users/anfid/.ghcup/env"
fi

if (( $+commands[rustc] )); then
  export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/library/
fi

export EDITOR='kak'
export WORDCHARS='~*-_.!?#$%^&\()[]{}<>"`'"'"
