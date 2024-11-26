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

set --global EDITOR kak
set --global WORDCHARS '~*-_.!?#$%^&\()[]{}<>"`'"'"

test -x /opt/homebrew/bin/brew && /opt/homebrew/bin/brew shellenv | source

status is-interactive || exit

if command -q rustc
    set --global RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/library/
end

