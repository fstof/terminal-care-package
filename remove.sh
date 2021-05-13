#!/bin/sh


rm -rf $HOME/.oh-my-zsh
rm -rf $HOME/.vim/bundle/Vundle.vim
rm -rf $HOME/.vimrc
rm -rf $HOME/.zshrc
rm -rf $HOME/.mainrc
rm -rf $HOME/.autocomplete
rm -rf $HOME/.vim/bundle
rm -rf $HOME/.p10k.zsh

echo "Symbolic links deleted"


if test "$(uname)" = "Darwin" ; then
  # MacOS
  font_dir="$HOME/Library/Fonts"
else
  # Linux
  font_dir="$HOME/.local/share/fonts"
  mkdir -p $font_dir
fi

echo "Fonts cant be removed you can manually remove them from $font_dir"
