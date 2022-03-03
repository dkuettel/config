set nocompatible

filetype on
filetype plugin on
syntax on

" modeline has a security problem
" https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
" probably soon fine again?
set modelines=0
set nomodeline

let mapleader=","
inoremap jj <Esc>

" escape sequences
set timeout timeoutlen=1000 " how long to wait until considering a sequence done (when not prefix-free)
set ttimeout ttimeoutlen=1 " how long to wait to consider an escape code done (quick esc exit from insert mode)
"set noesckeys " alternatively allows no esc codes in insert mode, very fast

set nobackup
set noswapfile
set hidden " allow unsaved buffers

set textwidth=0 wrapmargin=0 " no autowrap
set scrolloff=8 " always keep some context lines visible
set sidescrolloff=5
" showmatch actually briefly _jumps_ to the matching pair? not the same as highlighting, can interfere with things
set noshowmatch
set backspace=indent,eol,start " allow backspacing over everything in insert mode

set hlsearch " highlight search terms
set incsearch " show search matches as you type
nohl " no highlight at startup

" completion in command mode
" in nvim longest:full is good, in vim I think list:longest was better?
set wildchar=<Tab> wildmenu wildmode=longest:full

set lazyredraw " redraw only when necessary (e.g. not when macros run, or similar things)

" default tab settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set copyindent

" note
" autocmd FileType python setlocal ...
" sometimes works to overwrite settings
" but some settings are applied after autocommand
" so it's more robust to put it in ~/.config/nvim/after/[ftplugin|indent]/python.vim
" both are symlinked because I'm not sure which part should happen when, just do it twice

" command mode
nnoremap ; :
nnoremap q; q:
vmap ; :
vmap q; q:

" visual indicators
set listchars=tab:›\ ,trail:•,precedes:◂,extends:▸,nbsp:¿
"set listchars=tab:›\ ,trail:•,precedes:↢,extends:↣,nbsp:¿
set list
set breakindent
set showbreak=▸
"set showbreak=↪
let &breakat=' '
"let &breakat=' ^I!@*-+;:,./?'
set linebreak
set nowrap
map ,w :set wrap!<cr>

" splits
set splitbelow
set splitright
