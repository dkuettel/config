set nocompatible

filetype on
filetype plugin on
syntax on

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
set showmatch " highlight matching braces
set backspace=indent,eol,start " allow backspacing over everything in insert mode

set hlsearch " highlight search terms
set incsearch " show search matches as you type
nohl " no highlight at startup

set wildchar=<Tab> wildmenu wildmode=longest,list,full " completion in command mode

set lazyredraw " redraw only when necessary (e.g. not when macros run, or similar things)

" default tab settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set copyindent

" specific filetype settings

autocmd FileType vim setlocal
    \ tabstop=4 softtabstop=4 shiftwidth=4
    \ expandtab smarttab autoindent copyindent
    \ textwidth=0

autocmd FileType python setlocal
    \ tabstop=4 softtabstop=4 shiftwidth=4
    \ expandtab smarttab autoindent copyindent
    \ textwidth=0
    \ indentexpr= indentkeys=
autocmd FileType python inoremap <buffer> ' "
autocmd FileType python inoremap <buffer> " '

autocmd FileType yaml setlocal
    \ tabstop=2 softtabstop=2 shiftwidth=2
    \ expandtab smarttab autoindent copyindent
    \ textwidth=0
    \ indentexpr= indentkeys=

" note
" indentexpr= should stop any automatic indendation (?)
" indentkeys= should stop any reindentation when typing things like 'else:'

" command mode
nnoremap ; :
vmap ; :

" visual indicators
set listchars=tab:›\ ,trail:•,precedes:↢,extends:↣,nbsp:¿
set list
set breakindent " visual (not real) breaks
let &showbreak = '↪'  " visual break indicator
set nowrap
map ,w :set wrap!<cr>

" splits
set splitbelow
set splitright
