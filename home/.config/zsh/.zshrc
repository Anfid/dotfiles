export TERM=xterm-256color

# Language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [ -z "$ZDOTDIR" ]; then
  export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
fi

export ZINIT_HOME="$ZDOTDIR/zinit"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/"

# Show prompt instantly
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Create cache dir if missing
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir -p $ZSH_CACHE_DIR
fi

# Uncomment for profiling
#zmodload zsh/zprof

# load zinit or download if missing
if [[ ! -a $ZINIT_HOME/bin/zinit.zsh ]]; then
  git clone https://github.com/zdharma/zinit.git $ZINIT_HOME/bin
fi
source $ZINIT_HOME/bin/zinit.zsh

source $ZDOTDIR/plugins.zsh

# Load basic settings
for file in $ZDOTDIR/settings/*; do
  source $file
done

# Aliases
alias sd="shutdown" # [options]
alias q="exit"
alias e="$EDITOR"
alias wiki="kak -e 'wiki index.md'"
alias mutt="neomutt"

alias mntrw="sudo mount -o rw,gid=users,fmask=113,dmask=002" # device mount_point
alias mntro="sudo mount -o ro,gid=users,fmask=333,dmask=222" # device mount_point
alias unmnt="sudo umount" # mount_point

alias c='noglob calculate'
calculate() luajit -e "print($*)"

alias rustr=evcxr

if hash exa 2>/dev/null; then
    alias ls="exa"
    alias ll="exa -lah --git --group-directories-first"
    alias la="exa -a"
    alias lt="exa -Ta --group-directories-first"
    alias lti="noglob exa -Ta --group-directories-first -I" # ignore_glob
fi

if hash elm 2>/dev/null; then
    alias elm="https_proxy=elm.dmy.fr:9999 elm"
fi

alias glog="nvim +ShowCommitsAndExit"

# source local zshrc
[[ -f $HOME/.zshrclocal ]] && source $HOME/.zshrclocal
