set --global XDG_CONFIG_HOME "$HOME/.config"
set --global XDG_CACHE_HOME "$HOME/.cache"

if test -d "$HOME/.local/bin"
    fish_add_path -gp "$HOME/.local/bin"
end

if test -d "$HOME/.cargo/bin"
    fish_add_path -gp "$HOME/.cargo/bin"
end

if test -d "$HOME/.ghcup/bin"
    fish_add_path -gp "$HOME/.ghcup/bin"
end

set --global EDITOR hx
set --global WORDCHARS '~*-_.!?#$%^&\()[]{}<>"`'"'"

if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source

    if test -d "$HOMEBREW_PREFIX/opt/llvm/bin"
        fish_add_path --global --append "$HOMEBREW_PREFIX/opt/llvm/bin"
    end
end

status is-interactive || exit

if command -q rustc
    set --global RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/library/
end
