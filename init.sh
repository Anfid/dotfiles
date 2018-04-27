#!/bin/bash

# Compile YCM
# Run ":PluginInstall" in vim

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

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
