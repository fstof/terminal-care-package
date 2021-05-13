# Terminal (Linux / Mac)
## To install
```bash
# Clone the repo
git clone https://github.com/fstof/terminal-care-package.git ~/terminal-care-package
# CD into folder
cd ~/terminal-care-package
# Execute `setup.sh`
./setup.sh
```

## To uninstall
```bash
# CD out of folder
cd ~/
# execute remove script
~/terminal-care-package/remove.sh
# delete the leftovers
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