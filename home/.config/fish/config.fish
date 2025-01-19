status is-interactive || exit

if not functions -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
end

set --global fish_greeting ""

# Tide prompt
set --global tide_left_prompt_items pwd git
set --global tide_right_prompt_items status cmd_duration context jobs

set fzf_preview_dir_cmd eza --all --color=always

set --global BAT_THEME base16
