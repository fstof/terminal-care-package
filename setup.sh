#!/bin/sh
set -e

echo ""
echo "removing previously linked dotfiles"
rm -rf $HOME/.oh-my-zsh
rm -rf $HOME/.vim/bundle/Vundle.vim
rm -rf $HOME/.vimrc
rm -rf $HOME/.zshrc
rm -rf $HOME/.mainrc
rm -rf $HOME/.autocomplete
rm -rf $HOME/.vim/bundle
rm -rf $HOME/.p10k.zsh

echo ""
echo  "Vim"
  mkdir -p $HOME/.vim/bundle
  git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
  ln -s $HOME/terminal-care-package/dotfiles/vimrc $HOME/.vimrc
  vim +PluginInstall +qall

echo ""
echo "oh-my-zsh"
  git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
  ln -s $HOME/terminal-care-package/dotfiles/zshrc $HOME/.zshrc
  
  echo ""
  echo "powerlevel10k theme"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    ln -s $HOME/terminal-care-package/dotfiles/p10k.zsh $HOME/.p10k.zsh

  echo ""
  echo "agnoster-fstof theme"
    ln -s $HOME/terminal-care-package/zsh/agnoster-fstof.zsh-theme $HOME/.oh-my-zsh/custom/themes/agnoster-fstof.zsh-theme

  echo ""
  echo "zsh syntax highlighting"
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

  echo ""
  echo "zsh auto-suggestions"
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

echo ""
echo "Custom fonts for powerline and ligatures"
  # Set source and target directories
  new_fonts_dir="fonts"

  # if an argument is given it is used to select which fonts to install
  prefix="$1"

  if test "$(uname)" = "Darwin" ; then
    # MacOS
    font_dir="$HOME/Library/Fonts"
  else
    # Linux
    font_dir="$HOME/.local/share/fonts"
    mkdir -p $font_dir
  fi

  # Copy all fonts to user fonts directory
  echo "Copying fonts..."
  find "$new_fonts_dir" \( -name "$prefix*.[ot]tf" -or -name "$prefix*.pcf.gz" \) -type f -print0 | xargs -0 -n1 -I % cp "%" "$font_dir/"

  # Reset font cache on Linux
  if which fc-cache >/dev/null 2>&1 ; then
      echo "Resetting font cache, this may take a moment..."
      fc-cache -f "$font_dir"
  fi

  echo "Fonts installed to $font_dir"

echo ""
echo "Custom environment variables"
  ln -s $HOME/terminal-care-package/source_files/mainrc $HOME/.mainrc
  ln -s $HOME/terminal-care-package/source_files/autocomplete $HOME/.autocomplete
  vim $HOME/.mainrc
