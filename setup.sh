#!/bin/sh

rm $HOME/.vimrc
rm $HOME/.zshrc
rm $HOME/.mainrc
rm $HOME/.oh-my-zsh

ln -s $HOME/terminal-care-package/dotfiles/vimrc $HOME/.vimrc
ln -s $HOME/terminal-care-package/dotfiles/zshrc $HOME/.zshrc
ln -s $HOME/terminal-care-package/rcfiles/mainrc $HOME/.mainrc
ln -s $HOME/terminal-care-package/oh-my-zsh/ $HOME/.oh-my-zsh

echo "Symbolic links created"


# Set source and target directories
powerline_fonts_dir="fonts"

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
find "$powerline_fonts_dir" \( -name "$prefix*.[ot]tf" -or -name "$prefix*.pcf.gz" \) -type f -print0 | xargs -0 -n1 -I % cp "%" "$font_dir/"

# Reset font cache on Linux
if which fc-cache >/dev/null 2>&1 ; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f "$font_dir"
fi

echo "Powerline font installed to $font_dir"
