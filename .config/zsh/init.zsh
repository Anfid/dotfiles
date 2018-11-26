export TERM=xterm-256color

# Language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

zsh_conf=$HOME/.config/zsh

export ZPLUG_HOME=$zsh_conf/zplug

# load zplug or download if missing
if [[ -f $zsh_conf/zplug/init.zsh ]]; then
  source $zsh_conf/zplug/init.zsh
else
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

source $zsh_conf/plugins.zsh

# Load basic settings
for file in $zsh_conf/settings/*; do
  source $file
done

# source local zshrc
[[ -f $HOME/.zshrclocal ]] && source $HOME/.zshrclocal

# Aliases
alias sd="shutdown" # [options]
alias q="exit"

alias mntrw="sudo mount -o rw,gid=users,fmask=113,dmask=002" # device mount_point
alias mntro="sudo mount -o ro,gid=users,fmask=333,dmask=222" # device mount_point
alias unmnt="sudo umount" # mount_point

if hash exa 2>/dev/null; then
    alias ls="exa"
    alias ll="exa -lah --git --group-directories-first"
    alias la="exa -a"
    alias lt="exa -Ta --group-directories-first"
    alias lti="exa -Ta --group-directories-first -I" # ignore_glob
fi

alias glog="nvim +ShowCommitsAndExit"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
