# Terminal (Linux / Mac)
## Clone the repo
```bash
git clone https://github.com/fstof/terminal-care-package.git ~/terminal-care-package
```

## CD into folder
```bash
cd ~/terminal-care-package
```

## Execute `setup.sh`
```bash
./setup.sh
```
## To remove: Execute `remove.sh`
```bash
cd ~/
~/terminal-care-package/remove.sh
rm -rf ~/terminal-care-package
```

# Software (Mac)
## Install command line tools
```bash
xcode-select --install
```

## Install Homebrew and software
```bash
# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#install homebrew software
brew bundle --file ~/terminal-care-package/Brewfile
```