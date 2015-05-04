#!/bin/bash

sudo apt-get install vim
ln -s --backup ~/config/vimrc ~/.vimrc

# pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle
git clone git://github.com/altercation/vim-colors-solarized.git

