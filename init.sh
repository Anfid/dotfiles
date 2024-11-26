#!/bin/bash

c_R="[31m" # red
c_G="[32m" # green
c_Y="[33m" # yellow
c_C="[36m" # cyan
c_NO="[0m" # reset

DOTFILES_DIR="$( cd "$( dirname "$0" )" && pwd )"

while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
  -i|--init)
    INIT=yes
    shift
    ;;
  -g|--upgrade)
    UPGRADE=yes
    shift
    ;;
  -u|--update)
    UPDATE=yes
    shift
    ;;
  -l|--symlink)
    SYMLINK=yes
    shift
    ;;
  -h|--help)
    HELP=yes
    shift
    ;;
  *)
    HELP=yes
    echo -e "${c_R}Error:${c_NO} Unknown option used."
    ;;
  esac

  if [[ $HELP = yes ]]
  then
    echo -e "${c_Y}USAGE:${c_NO}
  ./init.sh [FLAGS]

${c_Y}FLAGS:${c_R}
  ${c_G}-h${c_NO}, ${c_G}--help${c_NO}          View this help message.
  ${c_G}-l${c_NO}, ${c_G}--symlink${c_NO}       Update symbolic links. Old files will be stored in dotfiles/old in case of conflicts.
  ${c_G}-i${c_NO}, ${c_G}--init${c_NO}          Initialize dotfiles. Supposed to run only once. Includes -d and -u flags.
  ${c_G}-g${c_NO}, ${c_G}--upgrade${c_NO}       Update github repositories.
  ${c_G}-u${c_NO}, ${c_G}--update${c_NO}        Update dotfiles.
"
    exit
  fi
done

# arg1 is confirmation message, user response is returned
# example: confirm 'hello?' && echo hello
function confirm {
  echo $1 '[y/N]'
  read -n1 -sr response
  response=${response,,}    # tolower
  if [[ "$response" = "y" ]]
  then
    return 0
  else
    return 1
  fi
}

function link_recursive {
  shopt -s dotglob
  set -o errexit

  local source="$1"
  local basedir="${2:-"$1"}"

  if [ "$source" = "$basedir" ]; then
    local common=""
  else
    local common=${source#"$basedir/"}
  fi

  local target="$HOME/$common"

  if [ "$(basename "$source")" = ".DS_Store" ]; then
    echo "Ignoring '$source'"
    # ignore
    true

  elif [ -d "$source" ]; then
    if [ ! -e "$target" ] && [ ! -L "$target" ]; then
      mkdir "$target"
    elif [ ! -d "$target" ] || [ -L "$target" ]; then
      echo "${c_C}Note:${c_NO} Moving $target to $DOTFILES_DIR/old..."
      mkdir -p "$(dirname "$DOTFILES_DIR/old/$common")"
      mv -f "$target" "$DOTFILES_DIR/old/$common"
      mkdir "$target"
    fi

    for entry in "$source"/*; do
      link_recursive "$entry" "$basedir"
    done

  elif [ -f "$source" ]; then
    if [ -f "$target" ] && [ ! -L "$target" ]; then
      echo "${c_C}Note:${c_NO} Moving $target to $DOTFILES_DIR/old..."
      mkdir -p $(dirname "$DOTFILES_DIR/old/$common")
      mv -f "$target" "$DOTFILES_DIR/old/$common"
    fi
    ln -sf "$source" "$target"

  else
    echo "${c_R}Error:${c_NO} $source does not exist"
    exit 1
  fi

  if [ "$source" = "$basedir" ]; then
    echo "Done!"
  fi

  set +o errexit
}

function install_icons {
  sudo cp -r "$DOTFILES_DIR/icons/Ardoise_no_shadow_75" /usr/share/icons
  if [[ -f /etc/alternatives/x-cursor-theme ]]
  then
    sudo ln -sf /etc/alternatives/x-cursor-theme /usr/share/icons/Ardoise_no_shadow_75/cursor.theme
  else
    sudo ln -sf /usr/share/icons/default/index.theme /usr/share/icons/Ardoise_no_shadow_75/cursor.theme
  fi
}

function update_dotfiles {
  cd "$DOTFILES_DIR" && git pull
  sed -i '/*\/local\/*/d' ./.git/info/exclude
  echo "*/local/*" >> .git/info/exclude

  confirm 'Do symlink update? (Old files will be stored in dotfiles/old in case of conflicts)' && \
    link_recursive

  confirm 'Install icons (cursor)?' && install_icons

  confirm 'Add fonts?' && fc-cache -fv
}

function install_from_rep {
  export PATH="$HOME/.cargo/bin:$PATH"

  rustup toolchain default stable
  rustup toolchain add nightly
  rustup component add rust-src rustfmt-preview clippy-preview rls

  sudo luarocks install lua-lsp
  sudo luarocks --lua-version 5.1 install luaposix
  sudo luarocks --lua-version 5.1 install luafilesystem
  sudo luarocks --lua-version 5.1 install bit32

  cargo install evcxr_repl
  cargo install cargo-update
}

function install_initial {
  sudo pacman -Syy --needed \
    git base-devel xclip udisks2 udiskie \
    kitty ripgrep fd exa bat fzf rofi picom playerctl python2-pip \
    python-pip python-pywal python-pygments mplayer rust-analyzer \
    rust-racer rustup luajit lua51 lua luarocks bash-language-server \
    flameshot neomutt prettier

  if ! hash yay 2>/dev/null; then
    echo
    echo "yay not found, installing..."
    echo
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
  fi

  yay -S --needed cquery bear lua-language-server-git i3lock-color picom-git cava

  if hash update-alternatives 2>/dev/null; then
    if hash kak 2>/dev/null; then
      kak_path=$(which kak)
      echo
      echo "Yes to all to use kakoune instead of vim"
      echo
      sudo update-alternatives --install /usr/bin/vi vi $kak_path 60
      sudo update-alternatives --config vi
      sudo update-alternatives --install /usr/bin/vim vim $kak_path 60
      sudo update-alternatives --config vim
      sudo update-alternatives --install /usr/bin/editor editor $kak_path 60
      sudo update-alternatives --config editor
    fi
  fi

  install_from_rep

  confirm 'Do symlink update? (Old files will be stored in dotfiles/old in case of conflicts)' && \
    link_recursive

  confirm 'Set colemak as default keyboard layout?' && \
    localectl set-keymap colemak
}

if [[ $UPDATE = yes ]]
then
  update_dotfiles
  exit
fi

if [[ $UPGRADE = yes ]]
then
  update_from_rep
  exit
fi

if [[ $INIT = yes ]]
then
  install_initial
  exit
fi

if [[ $SYMLINK = yes ]]
then
  link_recursive $DOTFILES_DIR/home
  exit
fi
