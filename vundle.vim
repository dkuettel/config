set nocompatible
filetype off

" install vundle: git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'altercation/vim-colors-solarized'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'easymotion/vim-easymotion'
Plugin 'davidhalter/jedi-vim'
Plugin 'xolox/vim-misc'
" Plugin 'xolox/vim-easytags' " todo trying with a manual background process, maybe vim8 background process new feature?
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mhinz/vim-signify' " show changes of file to git index
Plugin 'tmux-plugins/vim-tmux-focus-events'
Plugin 'sjl/gundo.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'

" Plugin 'mattboehm/vim-unstack'
" Plugin 'nathanaelkane/vim-indent-guides'

Plugin 'vim-python/python-syntax'

" run :PluginInstall
call vundle#end()
filetype plugin indent on
