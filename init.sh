#!/bin/bash

# Run ":PluginInstall" in vim
# Compile YCM

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DOTFILES_DIR && git pull
sed -i '/*\/local\/*/d' ./.git/info/exclude
echo "*/local/*" >> .git/info/exclude
git update-index --skip-worktree .zshrclocal.sh

ln -s $DOTFILES_DIR/.zshrc $HOME/.zshrc
if [[ -e $DOTFILES_DIR/.zshrclocal.sh ]]; then ln -s $DOTFILES_DIR/.zshrclocal.sh $HOME/.zshrclocal.sh; fi
ln -s $DOTFILES_DIR/.vimrc $HOME/.vimrc
ln -s $DOTFILES_DIR/.ideavimrc $HOME/.ideavimrc
ln -s $DOTFILES_DIR/.scripts $HOME/.scripts

# dependencies
sudo apt-get install -y software-properties-common python-dev python-pip python3-dev python3-pip wget ruby-sass sassc \
                        libxml2-utils gtk2-engines libimlib2 libimlib2-dev libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
                        libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev \
                        libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
                        libxkbfile-dev autoconf libxcb-xrm0 libxcb-xrm-dev libcairo2-dev python-xcbgen xcb-proto libxcb-image0-dev \
                        libxcb-ewmh-dev libpulse-dev libiw-dev automake

mkdir ~/.config/nvim
ln -s $DOTFILES_DIR/.config/nvim/init.vim $HOME/.config/nvim/init.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim

cd /tmp
git clone https://github.com/ierton/xkb-switch
mkdir xkb-switch/build && cd xkb-switch/build
cmake ..
make
sudo checkinstall -y --pkgname=xkbswitch

mkdir ~/.config/i3
ln -s $DOTFILES_DIR/.config/i3/config $HOME/.config/i3/config

mkdir ~/.config/rofi
ln -s $DOTFILES_DIR/.config/rofi/config $HOME/.config/rofi/config

mkdir ~/.config/powerline-shell
ln -s $DOTFILES_DIR/.config/powerline-shell/config.json $HOME/.config/powerline-shell/config.json

ln -s $DOTFILES_DIR/Wallpapers $HOME/Pictures/Wallpapers

ln -s $DOTFILES_DIR/.conkyrc $HOME/.conkyrc

mkdir $HOME/.config/polybar
ln -s $DOTFILES_DIR/.config/polybar/config $HOME/.config/polybar/config

ln -s $DOTFILES_DIR/.config/compton.conf $HOME/.config/compton.conf

ln -s $DOTFILES_DIR/.config/wal/templates $HOME/.config/wal/templates

ln -s $DOTFILES_DIR/.conky $HOME/.conky

ln -s $DOTFILES_DIR/.fonts $HOME/.fonts
fc-cache -fv

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

sudo apt-get update
sudo apt-get install -y silversearcher-ag

#neovim
sudo add-apt-repository -y ppa:neovim-ppa/stable
sudo apt-get install -y neovim
sudo apt-get install -y python-neovim python3-neovim

echo "Yes to all to use neovim instead of vim"
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --config vi
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --config vim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --config editor

# i3-gaps
# clone to ~/Programs/i3-gaps
cd /tmp
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
# compile & install
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make -j5
sudo checkinstall -y --pkgname=i3-gaps --pkgversion=1

sudo apt-get install -y i3status i3lock compton feh rofi conky
#pywal
sudo pip3 install pywal
#oomox
cd /tmp
wget http://ppa.launchpad.net/nilarimogard/webupd8/ubuntu/pool/main/o/oomox/oomox_1.2.6-1\~webupd8\~2_all.deb
dpkg -i oomox_1.2.6-1\~webupd8\~2_all.deb
#polybar
#NOTE: May need to recompile this later
cd /tmp
git clone --recursive https://github.com/jaagr/polybar
mkdir polybar/build
cd polybar/build
cmake ..
sudo checkinstall -y --pkgname=polybar

# Reminders. Possibly add to script later

# install rust via rustup. See manual for details.

# Install ripgrep via snap or cargo.
# Install exa via cargo

# Install FontAwesome for nice icons on i3 bar:
# Link: https://github.com/FortAwesome/Font-Awesome/releases
# Cheatsheet: https://fontawesome.com/cheatsheet?from=io
# And ofc Input font for neovim
