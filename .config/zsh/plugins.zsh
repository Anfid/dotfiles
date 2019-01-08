# Self-management
zplug 'zplug/zplug', hook-build:'zplug --self-manage'


########################################
#  Utilities, completions and aliases  #
########################################
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/pip",   from:oh-my-zsh
zplug "plugins/cargo", from:oh-my-zsh
zplug "zsh-users/zsh-completions"


##############################
#  Remind available aliases  #
##############################
zplug "djui/alias-tips"


##################
#  cd backwards  #
##################
zplug "Tarrasch/zsh-bd"


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
zplug "zsh-users/zsh-autosuggestions", hook-load:zsh-autosuggestions-override


###############
#  Powerline  #
###############
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

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
zplug "softmoth/zsh-vim-mode"
# viexchange messes up with syntax-highlighting. Make sure it loads after highlighting
zplug "okapia/zsh-viexchange", on:"softmoth/zsh-vim-mode", defer:3


##############################
#  Substring history search  #
##############################
# Load after vim-mode to prevent vim bindings to perform substring search
zplug "zsh-users/zsh-history-substring-search", defer:1


######################################
#  Close matching paired characters  #
######################################
zplug "hlissner/zsh-autopair", defer:2


######################
#  Syntax highlight  #
######################
zplug "zdharma/fast-syntax-highlighting", defer:2


# Install plugins if there are plugins that have not been installed
if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load
