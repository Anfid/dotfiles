export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

if [[ -d "$HOME/.local/bin" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

if (( $+commands[rustc] )); then
  export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src/
fi

export EDITOR='nvim'
export WORDCHARS='~*-_.!?#$%^&\()[]{}<>"`'"'"
