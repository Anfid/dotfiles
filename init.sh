#!/bin/bash

# Compile YCM
# Run ":PluginInstall" in vim

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DOTFILES_DIR && git pull
echo "*/local/*" >> .git/info/exclude # TODO: Update to write it only once

ln -s $DOTFILES_DIR/.zshrc $HOME/.zshrc
if [[ -e $DOTFILES_DIR/.zshrclocal.sh ]]; then ln -s $DOTFILES_DIR/.zshrclocal.sh $HOME/.zshrclocal.sh; fi
ln -s $DOTFILES_DIR/.vimrc $HOME/.vimrc
ln -s $DOTFILES_DIR/.ideavimrc $HOME/.ideavimrc
ln -s $DOTFILES_DIR/.scripts $HOME/.scripts
