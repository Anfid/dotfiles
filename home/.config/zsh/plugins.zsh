########################################
#  Utilities, completions and aliases  #
########################################
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit snippet OMZ::plugins/pip/pip.plugin.zsh
zinit ice as"completion"
zinit snippet OMZ::plugins/cargo/_cargo
zinit ice as"completion"
zinit snippet OMZ::plugins/httpie/_httpie
zinit light "zsh-users/zsh-completions"

# Optional
#zinit snippet OMZ::plugins/jira/jira.plugin.zsh

zinit snippet https://github.com/junegunn/fzf/raw/master/shell/key-bindings.zsh


##############################
#  Remind available aliases  #
##############################
zinit ice lucid wait"1"
zinit light "djui/alias-tips"


###########################
#  Fish-like suggestions  #
###########################
function zsh-autosuggestions-override() {
    ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(forward-char end-of-line)
    ZSH_AUTOSUGGEST_USE_ASYNC=true
    ZSH_AUTOSUGGEST_EXECUTE_WIDGETS=(menu-complete)
    ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
}
zinit ice lucid wait"0" atload"zsh-autosuggestions-override && _zsh_autosuggest_start"
zinit light "zsh-users/zsh-autosuggestions"


###############
#  Powerline  #
###############
zinit light "romkatv/powerlevel10k" #, use:powerlevel10k.zsh-theme

POWERLEVEL9K_MODE='nerdfont-complete'

# elements
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)

# dir
POWERLEVEL9K_HOME_ICON=''
POWERLEVEL9K_HOME_SUB_ICON=''
POWERLEVEL9K_FOLDER_ICON=''
POWERLEVEL9K_ETC_ICON=''
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
POWERLEVEL9K_SHORTEN_DELIMITER=""
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


##############################
#  Substring history search  #
##############################
zinit light "zsh-users/zsh-history-substring-search"


######################################
#  Close matching paired characters  #
######################################
zinit light "hlissner/zsh-autopair"


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
  _comp_options+=(globdots)

  unsetopt extendedglob
}
######################
#  Syntax highlight  #
######################
zinit ice lucid wait"0" atinit"_zcompinit_custom; zpcdreplay"
zinit light "zdharma/fast-syntax-highlighting"
