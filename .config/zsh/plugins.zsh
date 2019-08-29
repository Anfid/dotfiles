########################################
#  Utilities, completions and aliases  #
########################################
zplugin snippet OMZ::plugins/git/git.plugin.zsh
zplugin snippet OMZ::plugins/pip/pip.plugin.zsh
zplugin ice as"completion"
zplugin snippet OMZ::plugins/cargo/_cargo
zplugin ice as"completion"
zplugin snippet OMZ::plugins/httpie/_httpie
zplugin light "zsh-users/zsh-completions"

# Optional
#zplugin snippet OMZ::plugins/jira/jira.plugin.zsh


##############################
#  Remind available aliases  #
##############################
zplugin ice lucid wait"1"
zplugin light "djui/alias-tips"


##################
#  cd backwards  #
##################
zplugin ice lucid wait"1"
zplugin light "Tarrasch/zsh-bd"


###########################
#  Fish-like suggestions  #
###########################
function zsh-autosuggestions-override() {
    # ignore commands in vi-mode
    ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(forward-char end-of-line)
    ZSH_AUTOSUGGEST_USE_ASYNC=true
    ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=vi-cmd-mode
}
zplugin ice lucid wait"0" atload"_zsh_autosuggest_start"
zplugin light "zsh-users/zsh-autosuggestions"


###############
#  Powerline  #
###############
zplugin light "romkatv/powerlevel10k" #, use:powerlevel10k.zsh-theme

POWERLEVEL9K_MODE='awesome-fontconfig'

# elements
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vi_mode dir dir_writable vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)

# vi_mode
POWERLEVEL9K_VI_INSERT_MODE_STRING='I'
POWERLEVEL9K_VI_COMMAND_MODE_STRING='N'
POWERLEVEL9K_VI_MODE_INSERT_BACKGROUND='blue'
POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND='black'
POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND='green'
POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND='black'

# dir
POWERLEVEL9K_HOME_ICON=''
POWERLEVEL9K_HOME_SUB_ICON=''
POWERLEVEL9K_FOLDER_ICON=''
POWERLEVEL9K_ETC_ICON=''
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
POWERLEVEL9K_DIR_ETC_BACKGROUND='cyan'
POWERLEVEL9K_DIR_ETC_FOREGROUND='black'
POWERLEVEL9K_DIR_HOME_BACKGROUND='cyan'
POWERLEVEL9K_DIR_HOME_FOREGROUND='black'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='cyan'
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='black'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='cyan'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='black'

# vcs
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='black'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='green'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='black'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='black'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
POWERLEVEL9K_VCS_STAGED_ICON='✚'
POWERLEVEL9K_VCS_UNSTAGED_ICON='✎'
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='⬇'
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='⬆'
POWERLEVEL9K_VCS_COMMIT_ICON='~'

# status
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_STATUS_OK_FOREGROUND='black'
POWERLEVEL9K_STATUS_OK_BACKGROUND='green'
POWERLEVEL9K_STATUS_ERROR_FOREGROUND='black'
POWERLEVEL9K_STATUS_ERROR_BACKGROUND='red'

# command_execution_time
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=7
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='white'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='black'

# time
POWERLEVEL9K_TIME_FORMAT='%D{%l:%M%p}'


#############
#  VI-mode  #
#############
MODE_CURSOR_VICMD="blinking block"
MODE_CURSOR_VIINS="blinking bar"
zplugin light "softmoth/zsh-vim-mode"
# viexchange messes up with syntax-highlighting. Make sure it loads after highlighting
zplugin ice lucid wait"2"
zplugin light "okapia/zsh-viexchange"


##############################
#  Substring history search  #
##############################
# Load after vim-mode to prevent vim bindings to perform substring search
zplugin light "zsh-users/zsh-history-substring-search"


######################################
#  Close matching paired characters  #
######################################
zplugin light "hlissner/zsh-autopair"


##############
#  Compinit  #
##############
# Custom compinit function, prevents unnecessary compinit, also compiles completions
# See https://gist.github.com/ctechols/ca1035271ad134841284?source=post_page---------------------------#gistcomment-2894219
_zcompinit_custom() {
  setopt extendedglob
  autoload -Uz compinit
  local zcd=$ZSH_CACHE_DIR/.zcompdump
  local zcdc="$zcd.zwc"
  # Compile the completion dump to increase startup speed, if dump is newer or doesn't exist,
  # in the background as this is doesn't affect the current session
  if [[ -f "$zcd"(#qN.m+1) ]]; then
    compinit -i -d "$zcd"
    { rm -f "$zcdc" && zcompile "$zcd" } &!
  else
    compinit -C -d "$zcd"
    { [[ ! -f "$zcdc" || "$zcd" -nt "$zcdc" ]] && rm -f "$zcdc" && zcompile "$zcd" } &!
  fi
  unsetopt extendedglob
}
######################
#  Syntax highlight  #
######################
zplugin ice lucid wait"0" atinit"_zcompinit_custom; zpcdreplay"
zplugin light "zdharma/fast-syntax-highlighting"
