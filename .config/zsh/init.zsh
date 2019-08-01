export TERM=xterm-256color

# Language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export ZSH_CACHE_DIR="$HOME/.cache/zsh/"

zsh_conf="$HOME/.config/zsh"

export ZPLUGIN_HOME=$zsh_conf/zplugin

# Uncomment for profiling
#zmodload zsh/zprof

# load zplugin or download if missing
if [[ ! -a $ZPLUGIN_HOME/bin/zplugin.zsh ]]; then
  git clone https://github.com/zdharma/zplugin.git $ZPLUGIN_HOME/bin
fi
source $ZPLUGIN_HOME/bin/zplugin.zsh

source $zsh_conf/plugins.zsh

# Load basic settings
for file in $zsh_conf/settings/*; do
  source $file
done

# Aliases
alias sd="shutdown" # [options]
alias q="exit"

alias mntrw="sudo mount -o rw,gid=users,fmask=113,dmask=002" # device mount_point
alias mntro="sudo mount -o ro,gid=users,fmask=333,dmask=222" # device mount_point
alias unmnt="sudo umount" # mount_point

c() luajit -e "print($*)"

if hash exa 2>/dev/null; then
    alias ls="exa"
    alias ll="exa -lah --git --group-directories-first"
    alias la="exa -a"
    alias lt="exa -Ta --group-directories-first"
    alias lti="exa -Ta --group-directories-first -I" # ignore_glob
fi

alias glog="nvim +ShowCommitsAndExit"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# source local zshrc
[[ -f $HOME/.zshrclocal ]] && source $HOME/.zshrclocal
