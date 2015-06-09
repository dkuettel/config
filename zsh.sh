#!/bin/bash
set -ex

sudo apt-get install -y zsh

if [[ -d ~/.oh-my-zsh ]]
then
	echo 'oh my zsh is already installed'
else
	wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh
	chsh -s /usr/bin/zsh # seems like oh-my-zsh is doing that already, sometimes?
fi

if [[ $(realpath ~/config/zshrc) == $(realpath ~/.zshrc) ]]
then
	echo 'zshrc.sh already installed'
else
	ln -s --backup ~/config/zshrc ~/.zshrc
fi

[[ -d ~/plugins ]] || mkdir ~/plugins
cd ~/plugins

if [[ -d fonts ]]
then
	echo 'fonts already installed'
else
	git clone https://github.com/powerline/fonts.git
	cd fonts
	./install.sh
fi
