if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  startx
fi

if [[ -d "$HOME/.local/bin" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

if (( $+commands[rustc] )); then
  export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src/
fi
