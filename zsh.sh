#!/bin/bash

sudo apt-get install zsh
wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh
chsh -s /bin/zsh # seems like oh-my-zsh is doing that already, sometimes?
ln -s --backup ~/config/zshrc ~/.zshrc

mkdir -p ~/plugins
cd ~/plugins
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
