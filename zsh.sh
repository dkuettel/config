#!/bin/bash

sudo apt-get install -y zsh

if [[ ! -d ~/.oh-my-zsh ]]
then
	wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh
	sudo chsh -s /bin/zsh # seems like oh-my-zsh is doing that already, sometimes?
	ln -s --backup ~/config/zshrc ~/.zshrc
fi

mkdir ~/plugins
cd ~/plugins

if [[ ! -d fonts ]]
then
	git clone https://github.com/powerline/fonts.git
	cd fonts
	./install.sh
fi
