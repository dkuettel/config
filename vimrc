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
Plugin 'xolox/vim-easytags'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mhinz/vim-signify' " show changes of file to git index
Plugin 'tmux-plugins/vim-tmux-focus-events'
Plugin 'sjl/gundo.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'

" Plugin 'nathanaelkane/vim-indent-guides'

" run :PluginInstall
call vundle#end()
filetype plugin indent on
" filetype plugin on " todo for now, because I didn't like python indent, but I should customize python filetype

" core vim settings
let mapleader="," " default is \
set nobackup
set noswapfile
set hidden " allow unsaved buffers to hidden (does not autosave)
set textwidth=0 " disabled wrapping when typing
set hlsearch " highlight search terms
set incsearch " show search matches as you type
nohl " so that when starting up we dont already highlight and old search term
set wildchar=<Tab> wildmenu wildmode=longest,list,full " command completion in :...
set scrolloff=8 " always keep some context lines visible
set lazyredraw " redraw only when necessary (e.g. not when macros run, or similar things)
set showmatch " highlight matchin braces

" navigate splits
" todo does it disable the redraw on ctrl-l?
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" solarized
" set background=dark " the plugin considers dark the default, and it should fit with invertable colors
let g:solarized_termcolors=16 " 16 is better if set right, 256 is the compatible fixed color mode
let g:solarized_visibility="normal" " set list to see nonprint characters
colorscheme solarized

" higlight/show (problematic) whitespaces
" other options: http://vim.wikia.com/wiki/Highlight_unwanted_spaces
"set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
set listchars=tab:\|\ ,trail:•,extends:#,nbsp:. " todo its not bad but need a subtle color for the bar, solarized?
"set list

" default tab settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
"set smarttab
set autoindent
set copyindent
" overwrite filetypes
" todo should it not be instead changed in the filetype or have it " customized?
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
autocmd FileType cpp setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" easymotion
nmap s <Plug>(easymotion-overwin-f)

" ctrl p
let g:ctrlp_working_path_mode = 0 " always base off initial working folder
let g:ctrlp_switch_buffer = 0 " don't switch between splits when selecting a file/buffer to open, stay on split, makes it easier to open same file in many splits
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:20'
nnoremap <leader>. :CtrlPTag<cr>
nnoremap <leader>b :CtrlPBuffer<cr>

" --- testing new settings below here ---

filetype indent off
" hi CursorLine cterm=NONE ctermbg=gray ctermfg=lightblue
hi CursorLine cterm=NONE ctermbg=gray ctermfg=NONE " NONE for ctermfg lets fg color be -> syntaxcolors
set cursorline
set cursorcolumn
nnoremap ; :
:nnoremap X :set cursorline! cursorcolumn!<CR>

" jedi-vim settings
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = "2"

" have cursorline/column only in active window
augroup CursorLineOnlyInActiveWindow
	autocmd!
	autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline cursorcolumn
	" autocmd WinLeave * setlocal nocursorline nocursorcolumn
	autocmd WinLeave * setlocal nocursorcolumn
	" todo or maybe even change color to more subtle for inactive window?
augroup END

" todo semigood
" set virtualedit=all " problem is also over tabs

" easytags, try for now, maybe the syntax highlighting from here made it slow
set tags=./tags " use this file local to vim working directory
let g:easytags_dynamic_files = 2 " use tag file path relative to vim working folder, not active buffer
set cpoptions+=d " use tag file path relative to vim working folder, not active buffer file
let g:easytags_auto_highlight = 0 " don't do expensive highlighting based on tag file for now

" try airline
set laststatus=2 " not sure if needed
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extenstions#tabline#fnamemod = ':t'

" trying autosave and co
set autoread " autoread files if changed outside and not locally, on focus events, does not work out of the box in tmux vim
au FocusLost * :wa

" try undo tree
nnoremap <Leader>u :GundoToggle<CR>

" syntastic
" for newbies
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" from marcin
let g:syntastic_python_checkers=['flake8']
let g:syntastic_quiet_messages = { "type": "style" } " remove all style warnings
"let g:syntastic_python_flake8_args='--ignore=E501,E225,E251,E231,W191'
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
nmap ]l :lnext<CR>
nmap ]r :lprev<CR>
" from me
let g:syntastic_auto_jump = 1
let g:syntastic_mode_map = {"mode":"passive"}
nmap <leader>s :SyntasticCheck<CR>

" kinda cool, useful?
inoremap jj <Esc> " quick jj exit insert mode

" notes
" gi go to last insert mode in insert mode
" '' go to last insert mode

syntax on
