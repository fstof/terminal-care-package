#!/bin/sh

echo "removing previously linked dotfiles"

rm -rf $HOME/.oh-my-zsh
rm -rf $HOME/.vim/bundle/Vundle.vim
rm -rf $HOME/.vimrc
rm -rf $HOME/.zshrc
rm -rf $HOME/.mainrc
rm -rf $HOME/.autocomplete
rm -rf $HOME/.vim/bundle
rm -rf $HOME/.p10k.zsh
rm -rf $HOME/.config/nvim
rm -rf $HOME/.config/herdr/config.toml

echo "Symbolic links deleted"
