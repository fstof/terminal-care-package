## Install command line tools
```bash
xcode-select --install
```

## Clone the repo
```bash
git clone --recurse-submodules https://github.com/fstof/terminal-care-package.git ~/terminal-care-package
```

## CD into folder
```bash
cd ~/terminal-care-package
```

## Execute `setup.sh`
```bash
./setup.sh
```

## Install Homebrew and software
```bash
# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#install homebrew software
brew bundle -f ~/terminal-care-package/Brewfile
```