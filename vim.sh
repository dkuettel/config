#!/bin/bash -eux

sudo apt-get install -qy git

# not using vim package anymore because it's an older version
# sudo apt-get -qy install vim-nox
if [[ -d ~/vim ]]; then
	echo '~/vim already exists'
	git -C ~/vim pull
else
	echo 'cloning vim'
	git clone https://github.com/vim/vim.git ~/vim
fi
cd ~/vim
sudo apt-get install -qy libncurses5-dev # vim dependencies
./configure --disable-gui --without-x --enable-luainterp=dynamic --enable-perlinterp=dynamic --enable-pythoninterp=dynamic --enable-rubyinterp --enable-cscope --with-features=huge
make -j$(nproc)
sudo make install

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

# todo not sure I think needs new terminal to use new vim (bin paths), try explicit path here
# todo depends on terminal colors, ctags, python, ...
/usr/local/bin/vim -u ~/config/vundle.vim +PluginInstall +qall

# link custom files
if [[ ! -d ~/.vim ]]; then
	mkdir ~/.vim
fi
ln -sf ~/config/vim/syntax ~/.vim/syntax
ln -sf ~/config/vim/ftdetect ~/.vim/ftdetect
