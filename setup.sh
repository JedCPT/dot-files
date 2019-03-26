# Install command line developer tools
xcode-select --install

brew install tree

brew install fish

brew install vim

brew install wget

brew cask install iterm2

# Install Python linter
#brew install flake8

# Install latex packaes (Include unecessary junk).
#brew cask install mactex

# ***** Python installs *****
# Install newest version of python
# If you run into permission problems with
# homebrew on High Sierra then reinstall homebrew 
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install python3

pip3 install numpy
pip3 install scipy
pip3 install matplotlib

# Install version of tensorflow that matches the brew python version.
# python3 -m pip install --upgrade https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-0.12.0-py3-none-any.whl


# ***** GCC installs *****
#brew install gcc

# ***** Rust install *****
brew install rustup
rustup-init

#
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
