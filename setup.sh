rm $HOME/.vimrc
rm $HOME/.zshrc
rm $HOME/.mainrc
rm $HOME/.oh-my-zsh

ln -s $HOME/terminal-care-package/dotfiles/vimrc $HOME/.vimrc
ln -s $HOME/terminal-care-package/dotfiles/zshrc $HOME/.zshrc
ln -s $HOME/terminal-care-package/rcfiles/mainrc $HOME/.mainrc
ln -s $HOME/terminal-care-package/oh-my-zsh/ $HOME/.oh-my-zsh
