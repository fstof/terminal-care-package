#!/bin/sh
set -e

echo ""
./remove.sh

echo ""
echo "Vim"
mkdir -p $HOME/.vim/bundle
git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
ln -s $HOME/terminal-care-package/dotfiles/vimrc $HOME/.vimrc
vim +PluginInstall +qall

echo ""
echo "NeoVim"
ln -s $HOME/terminal-care-package/dotfiles/lazyVim $HOME/.config/nvim

echo ""
echo "Terminal"
echo "- Installing oh-my-zsh"
git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
ln -s $HOME/terminal-care-package/dotfiles/zshrc $HOME/.zshrc

echo ""
echo "- Installing Oh My Posh"
curl -s https://ohmyposh.dev/install.sh | bash -s

echo ""
echo "zsh syntax highlighting"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

echo ""
echo "zsh auto-suggestions"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

echo ""
echo "Custom fonts for powerline and ligatures"
oh-my-posh font install FiraCode
oh-my-posh font install NerdFontsSymbolsOnly

echo ""
echo "Custom environment variables"
ln -s $HOME/terminal-care-package/source_files/mainrc $HOME/.mainrc
ln -s $HOME/terminal-care-package/source_files/autocomplete $HOME/.autocomplete
vim $HOME/.mainrc
