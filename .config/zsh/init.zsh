zsh_conf=$HOME/.config/zsh

export ZPLUG_HOME=$zsh_conf/zplug

# load zplug or download if missing
if [[ -f $zsh_conf/zplug/init.zsh ]]; then
  source $zsh_conf/zplug/init.zsh
else
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# Load basic settings
for file in $zsh_conf/settings/*; do
  source $file
done

source $zsh_conf/plugins.zsh

[[ -f ~/.zshrclocal ]] && source ~/.zshrclocal

fpath+=~/.zsh.compl.d
compinit

autoload bashcompinit -U +X && bashcompinit
if [[ -d $HOME/.bash.compl.d ]]
then
  for bcompl in $HOME/.bash.compl.d/*
  do
    source $bcompl
  done
fi

export TERM=xterm-256color

# Language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# less settings
export LESS='--ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --window=-2'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# Set the Less input preprocessor.
if type lesspipe.sh >/dev/null 2>&1; then
  export LESSOPEN='|lesspipe.sh %s'
fi

if type pygmentize >/dev/null 2>&1; then
  export LESSCOLORIZER='pygmentize'
fi

# Aliases
alias sd="shutdown" # [options]
alias q="exit"

alias mntrw="sudo mount -o rw,gid=users,fmask=113,dmask=002" # device mount_point
alias mntro="sudo mount -o ro,gid=users,fmask=333,dmask=222" # device mount_point
alias unmnt="sudo umount" # mount_point

alias ls="exa"
alias ll="exa -lah --git --group-directories-first"
alias la="exa -a"
alias lt="exa -Ta --group-directories-first"
alias lti="exa -Ta --group-directories-first -I" # ignore_glob

alias glog="vim +ShowCommitsAndExit"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PYTHONIOENCODING=UTF-8

function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi

