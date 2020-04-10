#!/bin/sh

rm $HOME/.vimrc
rm $HOME/.zshrc
rm $HOME/.mainrc
rm $HOME/.autocomplete
rm $HOME/.oh-my-zsh
rm $HOME/.vim/bundle

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
