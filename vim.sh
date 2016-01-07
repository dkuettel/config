#!/bin/bash
set -ex

# install packages
sudo apt-get -qy install vim-nox

if [[ $(realpath ~/config/vimrc) == $(realpath ~/.vimrc) ]]
then
	echo '.vimrc is already configured'
else
	echo 'backup old .vimrc'
	ln -s --backup ~/config/vimrc ~/.vimrc
fi

# pathogen
[[ -d ~/.vim/autoload ]] || mkdir -p ~/.vim/autoload
[[ -d ~/.vim/bundle ]] || mkdir -p ~/.vim/bundle
if [[ -f ~/.vim/autoload/pathogen.vim ]]
then
	echo 'pathogen already installed'
else
#	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
	wget https://tpo.pe/pathogen.vim -O ~/.vim/autoload/pathogen.vim
fi

# solarized colors
cd ~/.vim/bundle
if [[ -d vim-colors-solarized ]]
then
	cd vim-colors-solarized
	git pull
else
#	git clone git://github.com/altercation/vim-colors-solarized.git
	git clone git@github.com:dkuettel/vim-colors-solarized.git
	cd vim-colors-solarized
	git config user.email 'dkuettel@gmail.com'
	git remote add upstream git://github.com/altercation/vim-colors-solarized.git
	git checkout mine
fi

# nerdtree
cd ~/.vim/bundle
if [[ -d nerdtree ]]
then
	cd nerdtree
	git pull
else
	git clone https://github.com/scrooloose/nerdtree.git
fi

# lusty juggler and file explorer
cd ~/.vim/bundle
if [[ -d lusty ]]
then
	cd lusty
	git pull
else
	git clone https://github.com/sjbach/lusty.git
fi

# easy motion
cd ~/.vim/bundle
if [[ -d vim-easymotion ]]
then
	cd vim-easymotion
	git pull
else
	git clone https://github.com/Lokaltog/vim-easymotion.git
fi

# auto save
cd ~/.vim/bundle
if [[ -d vim-auto-save ]]
then
	cd vim-auto-save
	git pull
else
	git clone https://github.com/907th/vim-auto-save.git
fi

# ctrl p
cd ~/.vim/bundle
if [[ -d ctrlp.vim ]]
then
	cd ctrlp.vim
	git pull
else
	# git clone https://github.com/kien/ctrlp.vim.git
	git clone https://github.com/ctrlpvim/ctrlp.vim.git
fi

# fugitive
cd ~/.vim/bundle
if [[ -d vim-fugitive ]]
then
	cd vim-fugitive
	git pull
else
	git clone https://github.com/tpope/vim-fugitive.git
fi

# arg text objects (a for argument, daa = delete an argument)
cd ~/.vim/bundle
if [[ -d argtextobj.vim ]]
then
	cd argtextobj.vim
	git pull
else
	git clone https://github.com/vim-scripts/argtextobj.vim.git
fi

# nerdcommenter
cd ~/.vim/bundle
if [[ -d nerdcommenter ]]
then
	cd nerdcommenter
	get pull
else
	git clone https://github.com/scrooloose/nerdcommenter.git
fi

# syntastic
cd ~/.vim/bundle
if [[ -d syntastic ]]
then
	cd syntastic
	get pull
else
	git clone https://github.com/scrooloose/syntastic.git
fi
