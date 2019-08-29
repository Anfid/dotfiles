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

# arg1 is relative to dotfiles file name
# e.g. safe_link .config/nvim/init.vim will store old init.vim in $DOTFILES_DIR/old/.config/nvim/init.vim
# and create a symbolic link from $DOTFILES_DIR/.config/nvim/init.vim to $HOME/.config/nvim/init.vim
function safe_link {
  file="$1"
  [[ -f $HOME/$file && ! -L $HOME/$file ]] && \
    mkdir -p "$(dirname "$DOTFILES_DIR/old/$file")" && \
    mv -f "$HOME/$file" "$DOTFILES_DIR/old/$file" && \
    echo "Note: $HOME/$file is now stored in $DOTFILES_DIR/old"
  ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
}

function safe_link_dir {
  dir="$1"
  [[ -d $HOME/$dir && ! -L $HOME/$dir ]] && \
    mkdir -p "$(dirname "$DOTFILES_DIR/old/$dir")" && \
    mv -f "$HOME/$dir" "$DOTFILES_DIR/old/$dir" && \
    echo "Note: $HOME/$dir is now stored in $DOTFILES_DIR/old"
  [[ -d $HOME/$dir && -L $HOME/$dir ]] && \
      rm "$HOME/$dir"
  ln -sf "$DOTFILES_DIR/$dir" "$HOME/$dir"
}

function update_symlink {
  echo 'Do symlink update? (Required for proper work. Old files will be stored in dotfiles/old) [y/N]'
  read -n1 -sr response
  response=${response,,}    # tolower
  case "$response" in
  "y")
    safe_link .xinitrc
    safe_link .zshrc
    safe_link .zprofile
    safe_link ".gtkrc-2.0"
    ln -sf "$DOTFILES_DIR/.scripts" "$HOME"
    [[ ! -d $HOME/Pictures ]] && mkdir "$HOME/Pictures"
    ln -sf "$DOTFILES_DIR/Wallpapers" "$HOME/Pictures/"
    safe_link_dir .conky
    [[ ! -d $HOME/.fonts ]] && mkdir "$HOME/.fonts"
    ln -sf "$DOTFILES_DIR"/.fonts/* "$HOME/.fonts"
    [[ ! -d $HOME/.config ]] && mkdir "$HOME/.config"

    for DOTFILES_CONF_DIR in $DOTFILES_DIR/.config/*/
    do
      CONF_SUBDIR=${DOTFILES_CONF_DIR#"$DOTFILES_DIR/"}
      CONF_SUBDIR=${CONF_SUBDIR%"/"}
      [[ ! -d $HOME/$CONF_SUBDIR ]] && mkdir "$HOME/$CONF_SUBDIR"
      for DOTFILES_CONF_SUBDIR_SUB in $DOTFILES_DIR/$CONF_SUBDIR/*
      do
        CONF_SUBDIR_SUB=${DOTFILES_CONF_SUBDIR_SUB#"$DOTFILES_DIR/"}
        [[ -f $DOTFILES_CONF_SUBDIR_SUB ]] && \
            safe_link "$CONF_SUBDIR_SUB"
        [[ -d $DOTFILES_CONF_SUBDIR_SUB ]] && \
            safe_link_dir "$CONF_SUBDIR_SUB"
      done
    done
    if [[ -f $HOME/.cache/wal/qutebrowser.yml ]]
    then
      ln -sf "$HOME/.cache/wal/qutebrowser.yml" "$HOME/.config/qutebrowser/colors.yml"
    else
      echo "Qutebrowser colors not generated by pywal. Generate colorscheme and update symlinks again."
    fi
    echo Done!
    ;;
  *)
    echo Canceled link update
    ;;
  esac
}

function install_dependencies {
  echo 'Install dependencies? Errors may occur if dependencies are not installed [y/N]'
  read -n1 -sr
  case "${REPLY,,}" in
  "y")
    #TODO: Consider renaming icons section to theme section and move arc-theme there
    sudo apt install software-properties-common python-dev python-pip python3-dev python3-pip wget ruby-sass \
                     libxml2-utils gtk2-engines libimlib2 libimlib2-dev libxcb1 libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
                     libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev \
                     libev-dev libxcb-cursor-dev libxcb-dpms0-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev \
                     libxkbcommon-x11-dev libxkbcommon-x11-0 libxkbfile-dev autoconf libxcb-composite0 libxcb-composite0-dev \
                     libxcb-xrm0 libxcb-xrm-dev libcairo-dev libcairo2-dev python-xcbgen xcb-proto libxcb-image0-dev \
                     libxcb-ewmh-dev libpulse-dev libiw-dev automake pkg-config libpam-dev libx11-dev libx11-xcb-dev libxkbcommon0 \
                     libharfbuzz-bin libharfbuzz-dev libpng-dev libxcursor-dev libxrandr-dev libxi-dev \
                     libxinerama-dev libgl1-mesa-dev zlib1g-dev libdbus-1-dev libgtk-3-dev libxss-dev libxdg-basedir-dev \
                     arc-theme gcal w3m-img ffmpegthumbnailer
    ;;
  *)
    echo 'Skipping dependencies'
    ;;
  esac
}

function install_icons {
  echo 'Install icons (cursor)? [y/N]'
  read -n1 -sr
  case "${REPLY,,}" in
  "y")
    sudo cp -r "$DOTFILES_DIR/icons/Ardoise_no_shadow_75" /usr/share/icons
    if [[ -f /etc/alternatives/x-cursor-theme ]]
    then
      sudo ln -sf /etc/alternatives/x-cursor-theme /usr/share/icons/Ardoise_no_shadow_75/cursor.theme
    else
      sudo ln -sf /usr/share/icons/default/index.theme /usr/share/icons/Ardoise_no_shadow_75/cursor.theme
    fi
    ;;
  *)
    echo 'Skipping installing icons'
    ;;
  esac

}

function update_dotfiles {
  cd "$DOTFILES_DIR" && git pull
  sed -i '/*\/local\/*/d' ./.git/info/exclude
  echo "*/local/*" >> .git/info/exclude

  install_dependencies
  update_symlink
  install_icons

  echo 'Add fonts? [y/N]'
  read -n1 -sr
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

  curl https://sh.rustup.rs -sSf | sh
  rustup toolchain add nightly
  rustup component add rust-src
  rustup component add rustfmt-preview
  rustup component add clippy-preview

  cargo install fd-find
  cargo install ripgrep
  cargo install exa
  cargo install cargo-update
  cargo install rusty-tags

  # kitty
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n dest="$HOME"/.local/opt
  ln -sf "$HOME/.local/opt/kitty.app/bin/kitty" "$HOME/.local/bin/"
  cp -rf "$HOME"/.local/opt/kitty.app/share/*   "$HOME/.local/share/"

  # xkbswitch
  cd /tmp && \
  git clone https://github.com/ierton/xkb-switch && \
  mkdir xkb-switch/build && cd xkb-switch/build && \
  cmake .. && \
  make && \
  sudo checkinstall -y --pkgname=xkb-switch

  # fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install"

  # less
  cd /tmp && \
  git clone https://github.com/wofr06/lesspipe.git && \
  cd lesspipe && \
  ./configure --yes && \
  sudo cp lesspipe.sh code2color /usr/bin && \
  pip3 install Pygments
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

  update_symlink
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

  # i3lock-color
  cd /tmp && \
  git clone https://github.com/PandorasFox/i3lock-color && \
  cd i3lock-color && \
  git tag -f "git-$(git rev-parse --short HEAD)" && \
  autoreconf -i && ./configure && make && \
  sudo checkinstall -y --pkgname=i3lock-color --pkgversion="$(date '+%y%m%d')"

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
