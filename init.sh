#!/bin/bash

c_R="[31m" # red
c_G="[32m" # green
c_Y="[33m" # yellow
c_C="[36m" # cyan
c_NO="[0m" # reset

distro="$(lsb_release -i | sed 's/.*:[^A-Za-z0-9]*//')"

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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

# arg1 is confirmation message
# example: confirm 'hello?' && echo hello
function confirm {
  echo $1 '[y/N]'
  read -n1 -sr response
  response=${response,,}    # tolower
  if [[ $response = "y" ]]
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

  if [ -d "$source" ]; then
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
    echo Done!
  fi

  set +o errexit
}

function install_dependencies {
  case $distro in
  Ubuntu)
    sudo apt install \
      software-properties-common python-dev python-pip python3-dev python3-pip wget ruby-sass \
      libxml2-utils gtk2-engines libimlib2 libimlib2-dev libxcb1 libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
      libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev \
      libev-dev libxcb-cursor-dev libxcb-dpms0-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev \
      libxkbcommon-x11-dev libxkbcommon-x11-0 libxkbfile-dev autoconf libxcb-composite0 libxcb-composite0-dev \
      libxcb-xrm0 libxcb-xrm-dev libcairo-dev libcairo2-dev python-xcbgen xcb-proto libxcb-image0-dev \
      libxcb-ewmh-dev libpulse-dev libiw-dev automake pkg-config libpam-dev libx11-dev libx11-xcb-dev libxkbcommon0 \
      libharfbuzz-bin libharfbuzz-dev libpng-dev libxcursor-dev libxrandr-dev libxi-dev \
      libxinerama-dev libgl1-mesa-dev zlib1g-dev libdbus-1-dev libgtk-3-dev libxss-dev libxdg-basedir-dev \
      gcal w3m-img ffmpegthumbnailer
    ;;
  ManjaroLinux)
    # No dependencies are required currently
    ;;
  esac
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

  confirm 'Install dependencies? Errors may occur if dependencies are not installed' && \
    install_dependencies

  confirm 'Do symlink update? (Old files will be stored in dotfiles/old in case of conflicts)' && \
    link_recursive

  confirm 'Install icons (cursor)?' && install_icons

  confirm 'Add fonts?' && fc-cache -fv
}

function install_from_rep {
  confirm 'Install dependencies? Errors may occur if dependencies are not installed' && \
    install_dependencies

  case $distro in
  ManjaroLinux)
    export PATH="$HOME/.cargo/bin:$PATH"
    rustup toolchain default stable
    rustup toolchain add nightly
    rustup component add rust-src rustfmt-preview clippy-preview rls
    sudo luarocks install luaposix
    sudo luarocks --lua-version 5.1 install luaposix
    sudo luarocks install luafilesystem
    sudo luarocks --lua-version 5.1 install luafilesystem
    ;;
  Ubuntu)
    curl https://sh.rustup.rs -sSf | sh
    export PATH="$HOME/.cargo/bin:$PATH"

    rustup toolchain add nightly
    rustup component add rust-src rustfmt-preview clippy-preview rls

    cargo install fd-find
    cargo install ripgrep
    cargo install exa
    cargo install bat

    # kitty
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n dest="$HOME"/.local/opt
    mkdir -p $HOME/.local/bin
    mkdir -p $HOME/.local/share
    ln -sf "$HOME/.local/opt/kitty.app/bin/kitty" "$HOME/.local/bin/"
    cp -rf "$HOME"/.local/opt/kitty.app/share/*   "$HOME/.local/share/"

    # fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install"

    # i3lock-color
    cd /tmp && \
    git clone https://github.com/PandorasFox/i3lock-color && \
    cd i3lock-color && \
    git tag -f "git-$(git rev-parse --short HEAD)" && \
    autoreconf -i && ./configure && make && \
    sudo checkinstall -y --pkgname=i3lock-color --pkgversion="$(date '+%y%m%d')"

    # less
    cd /tmp && \
    git clone https://github.com/wofr06/lesspipe.git && \
    cd lesspipe && \
    ./configure --yes && \
    sudo cp lesspipe.sh code2color /usr/bin

    sudo pip3 install Pygments
    ;;
  esac

  cargo install cargo-update
  cargo install rusty-tags
}

function update_from_rep {
  # TODO
  echo 'TODO: upgrade'
}

function install_initial {
  #neovim
  case $distro in
  Ubuntu)
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt install -y neovim python-neovim python3-neovim

    sudo apt install -y mps-youtube youtube-dl mplayer python-pywal arc-theme

    #pywal
    sudo pip3 install pywal
    ;;
  ManjaroLinux)
    sudo pacman -Syy \
      kitty ripgrep fd exa bat i3lock-color fzf python2-pip python-pip \
      python-pywal python-pygments mps-youtube mplayer rust-racer rustup \
      luajit lua51 lua luarocks

    yay -S bash-language-server cquery bear
    ;;
  esac

  if hash update-alternatives 2>/dev/null
  then
    echo "Yes to all to use neovim instead of vim"
    sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
    sudo update-alternatives --config vi
    sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
    sudo update-alternatives --config vim
    sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
    sudo update-alternatives --config editor
  fi

  install_from_rep

  confirm 'Do symlink update? (Old files will be stored in dotfiles/old in case of conflicts)' && \
    link_recursive
}

function install_i3 {
  # i3-gaps
  cd /tmp && \
  git clone https://www.github.com/Airblader/i3 i3-gaps && \
  cd i3-gaps && \
  autoreconf --force --install && \
  rm -rf build/* && cd build/ && \
  ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers && \
  make -j5 && \
  sudo checkinstall -y --pkgname=i3-gaps --pkgversion="$(date '+%y%m%d')"

  sudo apt install -y i3status compton feh rofi conky conky-all numlockx

  # polybar
  cd /tmp && \
  git clone --recursive https://github.com/jaagr/polybar && \
  mkdir polybar/build && cd polybar/build && \
  cmake .. && \
  sudo checkinstall -y --pkgname=polybar --pkgversion="$(date '+%y%m%d')"

  # dunst
  cd /tmp && \
  git clone https://github.com/dunst-project/dunst.git && \
  cd dunst && \
  make && \
  sudo checkinstall -y --pkgname=dunst --pkgversion="$(date '+%y%m%d')"

  cargo install i3-bg-blur
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
