#!/bin/bash

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
  *)
    echo 'Unknown option used.
Usage:
  ./init.sh [Options]

Options:
  -i, --init          Initialize dotfiles. Supposed to run only once. Includes -d and -u flags.
  -g, --upgrade       Update github repositories.
  -u, --update        Update dotfiles.
'
    exit
    ;;
  esac
done

function update_symlink {
  echo 'Do force symlink update? (Required for proper work but may remove original files) [y/N]'
  read -n1 -s response
  response=${response,,}    # tolower
  case "$response" in
  "y")
    ln -sf $DOTFILES_DIR/.xinitrc $HOME
    ln -sf $DOTFILES_DIR/.zshrc $HOME
    ln -sf $DOTFILES_DIR/.scripts $HOME
    ln -sf $DOTFILES_DIR/Wallpapers $HOME/Pictures
    ln -sf $DOTFILES_DIR/.conky $HOME
    ln -sf $DOTFILES_DIR/.fonts $HOME
    [[ ! -d $HOME/.config ]] && mkdir $HOME/.config
    ln -sf $DOTFILES_DIR/.config/* $HOME/.config
    echo Done!
    ;;
  *)
    echo Canceled link update
    ;;
  esac
}

function install_dependencies {
  echo 'Install dependencies? Errors may occur if dependencies are not installed [y/N]'
  read -n1 -s
  case "${REPLY,,}" in
  "y")
    sudo apt install software-properties-common python-dev python-pip python3-dev python3-pip wget ruby-sass \
                     libxml2-utils gtk2-engines libimlib2 libimlib2-dev libxcb1 libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
                     libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev \
                     libev-dev libxcb-cursor-dev libxcb-dpms0-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev \
                     libxkbcommon-x11-dev libxkbcommon-x11-0 libxkbfile-dev autoconf libxcb-composite0 libxcb-composite0-dev \
                     libxcb-xrm0 libxcb-xrm-dev libcairo-dev libcairo2-dev python-xcbgen xcb-proto libxcb-image0-dev \
                     libxcb-ewmh-dev libpulse-dev libiw-dev automake pkg-config libpam-dev libx11-dev libx11-xcb-dev libxkbcommon0
    ;;
  *)
    echo 'Skipping dependencies'
    ;;
  esac
}

function update_dotfiles {
  cd $DOTFILES_DIR && git pull
  sed -i '/*\/local\/*/d' ./.git/info/exclude
  echo "*/local/*" >> .git/info/exclude

  install_dependencies
  update_symlink

  echo 'Add fonts? [y/N]'
  read -n1 -s
  case "${REPLY,,}" in
  "y")
    fc-cache -fv
    ;;
  *)
    echo 'Skipping adding fonts'
    ;;
  esac
}

function install_from_rep {
  install_dependencies

  git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim

  # xkbswitch
  cd /tmp
  git clone https://github.com/ierton/xkb-switch
  mkdir xkb-switch/build && cd xkb-switch/build
  cmake ..
  make
  sudo checkinstall -y --pkgname=xkbswitch

  # fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
  $HOME/.fzf/install

  # i3-gaps
  cd /tmp
  git clone https://www.github.com/Airblader/i3 i3-gaps
  cd i3-gaps
  autoreconf --force --install
  rm -rf build/
  mkdir -p build && cd build/
  ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
  make -j5
  sudo checkinstall -y --pkgname=i3-gaps --pkgversion=1

  sudo apt install -y i3status compton feh rofi conky numlockx

  #polybar
  cd /tmp
  git clone --recursive https://github.com/jaagr/polybar
  mkdir polybar/build
  cd polybar/build
  cmake ..
  sudo checkinstall -y --pkgname=polybar

  #i3lock-color
  cd /tmp
  git clone https://github.com/PandorasFox/i3lock-color
  cd i3lock-color
  git tag -f "git-$(git rev-parse --short HEAD)"
  autoreconf -i && ./configure && make
  sudo checkinstall -y --pkgname=i3lock-color --pkgversion=1
}

function update_from_rep {
  # TODO
  echo 'TODO: upgrade'
}

function install_initial {
  #neovim
  sudo add-apt-repository -y ppa:neovim-ppa/stable
  sudo apt install -y neovim
  sudo apt install -y python-neovim python3-neovim

  echo "Yes to all to use neovim instead of vim"
  sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
  sudo update-alternatives --config vi
  sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
  sudo update-alternatives --config vim
  sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
  sudo update-alternatives --config editor

  # mps-youtube
  sudo apt install mps-youtube youtube-dl mplayer

  install_from_rep

  #pywal
  sudo pip3 install pywal

  #oomox
  cd /tmp
  wget http://ppa.launchpad.net/nilarimogard/webupd8/ubuntu/pool/main/o/oomox/oomox_1.2.6-1\~webupd8\~2_all.deb
  dpkg -i oomox_1.2.6-1\~webupd8\~2_all.deb
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

# Reminders. Possibly add to script later

# install rust via rustup. See manual for details.

# Install ripgrep via snap or cargo.
# Install exa via cargo

# Install FontAwesome for nice icons on i3 bar:
# Link: https://github.com/FortAwesome/Font-Awesome/releases
# Cheatsheet: https://fontawesome.com/cheatsheet?from=io
# And ofc Input font for neovim
