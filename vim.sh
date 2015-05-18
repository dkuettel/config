#!/bin/bash

sudo apt-get install vim-nox
ln -s --backup ~/config/vimrc ~/.vimrc

# pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle
git clone git://github.com/altercation/vim-colors-solarized.git

# nerdtree
cd ~/.vim/bundle
git clone https://github.com/scrooloose/nerdtree.git

# lusty juggler and file explorer
cd ~/.vim/bundle
git clone https://github.com/sjbach/lusty.git

# easy motion
cd ~/.vim/bundle
git clone https://github.com/Lokaltog/vim-easymotion.git
