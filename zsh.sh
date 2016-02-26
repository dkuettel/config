#!/bin/bash
set -eux

sudo apt-get install -y zsh

if [[ -d ~/.oh-my-zsh ]]
then
	echo 'oh my zsh is already installed'
	cd ~/.oh-my-zsh
	git pull
else
	cd ~
	git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
	chmod go-r -R ~/.oh-my-zsh
	chsh -s $(which zsh) # doesn't seem to take effect in the current session (tmux session?)
fi

if [[ $(realpath ~/config/zshrc) == $(realpath ~/.zshrc) ]]
then
	echo 'zshrc.sh already installed'
else
	ln -s --backup ~/config/zshrc ~/.zshrc
fi

# ls colors
[[ -d ~/plugins ]] || mkdir ~/plugins
if [[ -d ~/plugins/dircolors-solarized ]]
then
	echo 'dircolors solarized already installed'
	cd ~/plugins/dircolors-solarized
	git pull
else
	git clone https://github.com/seebi/dircolors-solarized.git ~/plugins/dircolors-solarized
fi

# zsh syntax highlighting plugin
if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]
then
	echo 'zsh-syntax-highlighting already installed'
	cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git pull
else
	git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

[[ -d ~/plugins ]] || mkdir ~/plugins
if [[ -d ~/plugins/fonts ]]
then
	echo 'fonts already installed'
	cd ~/plugins/fonts
	git pull
else
	git clone https://github.com/powerline/fonts.git ~/plugins/fonts
	cd ~/plugins/fonts
	./install.sh
fi

echo 'remember to select a patched font in your terminal'
