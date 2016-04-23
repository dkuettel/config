#!/bin/bash -xeu

# install packages
# todo use custom compile
sudo apt-get -qy install vim-nox

if [[ -f ~/.vimrc ]]; then
	if [[ $(realpath ~/config/vimrc) == $(realpath ~/.vimrc) ]]; then
		echo '.vimrc is already configured'
	else
		echo 'backup old .vimrc'
		ln -s --backup ~/config/vimrc ~/.vimrc
	fi
else
	echo 'no old .vimrc'
	ln -s ~/config/vimrc ~/.vimrc
fi

# vundle
if [[ -d ~/.vim/bundle/Vundle.vim ]]; then
	echo 'vundle already installed'
	git -C ~/.vim/bundle/Vundle.vim pull
else
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
