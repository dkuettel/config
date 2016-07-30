#!/bin/bash -eux

sudo apt-get install -qy zsh
chsh -s $(which zsh) # doesn't seem to take effect in the current session (tmux session?)

# antigen
if [[ -d ~/antigen ]]; then
	echo 'antigen exists'
	git -C ~/antigen pull
else
	git clone https://github.com/zsh-users/antigen.git ~/antigen
fi


if [[ -f ~/.zshrc ]]; then
	if [[ $(realpath ~/config/zshrc) == $(realpath ~/.zshrc) ]]; then
		echo '.zshrc already linked'
	else
		echo 'backup old .zshrc'
		ln -s --backup ~/config/zshrc ~/.zshrc
	fi
else
	echo 'link .zshrc'
	ln -s ~/config/zshrc ~/.zshrc
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
