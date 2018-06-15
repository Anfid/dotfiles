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

mkdir ~/.config/nvim
ln -s $DOTFILES_DIR/.config/nvim/init.vim $HOME/.config/nvim/init.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim

mkdir ~/.config/i3
ln -s $DOTFILES_DIR/.config/i3/config $HOME/.config/i3/config

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

sudo apt-get update
sudo apt-get install -y silversearcher-ag

sudo apt-get install -y software-properties-common python-dev python-pip python3-dev python3-pip

#neovim
sudo add-apt-repository -y ppa:neovim-ppa/stable
sudo apt-get install -y neovim
sudo apt-get install -y python-neovim python3-neovim

# i3
sudo apt-get install -y i3 i3status compton feh wal
echo "Yes to all to use neovim instead of vim"
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --config vi
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --config vim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --config editor

# Reminders. Possibly add to script later

# install rust via rustup. See manual for details.

# Install ripgrep via snap or cargo.

# Install FontAwesome for nice icons on i3 bar:
# Link: https://github.com/FortAwesome/Font-Awesome/releases
# Cheatsheet: https://fontawesome.com/cheatsheet?from=io
# And ofc Input font for neovim
