
" makes it behave like vim, instead of like vi
" should be off by default anyway as long as there is a .vimrc file
set nocompatible

set t_Co=16 " vim-colors-solarized, but has no effect (?)

" allows to install extensions as "bundles"
" https://github.com/tpope/vim-pathogen
call pathogen#infect()

" default mapleader was "\" but "," seems easier
let mapleader=","

" Quickly edit/reload the vimrc file
"nmap <silent> <leader>ev :e $MYVIMRC<CR>
"nmap <silent> <leader>sv :so $MYVIMRC<CR>

" don't need to save buffers when switching (does not imply autosave)
set hidden

"set nowrap " don't wrap lines
set tabstop=4 " a tab is X spaces
set shiftwidth=4 " number of spaces to use for autoindenting
set shiftround " use multiple of shiftwidth when indenting with '<' and '>'
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent " always set autoindenting on
set copyindent " copy the previous indentation on autoindenting
set number " always show line numbers
set showmatch " set show matching parenthesis
set ignorecase " ignore case when searching
set smartcase " ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab " insert tabs on the start of a line according to shiftwidth, not tabstop
set hlsearch " highlight search terms
set incsearch " show search matches as you type

set history=1000 " remember more commands and search history
set undolevels=1000 " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title " change the terminal's title
set visualbell " don't beep
set noerrorbells " don't beep

set nobackup
set noswapfile

" no smartness (autoindenting,...) while pasteing from outside
"set pastetoggle=F2

" make command line two lines high
" does not work nice with powerline, powerline already uses a line, 3 in total then
"set ch=2

" hide the mouse when typing text
set mousehide

" use mouse to scroll
" TODO cannot use terminal mark&copy anymore, need to toggle
"set mouse=a
set mouse=""

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" I like highlighting strings inside C comments
let c_comment_strings=1

" Switch on syntax highlighting if it wasn't on yet.
syntax on

" TODO not sure for what?
set t_kb=
fixdel
set t_kD=[3~

" shortcuts for working with latex files in a tmux session
" map <F2> :w<CR>:!tmux send-keys -t left './compile.sh' Enter <CR><CR>
" map <F3> :w<CR>:!tmux send-keys -t left 'svns' Enter <CR><CR>
" map <F4> :w<CR>:!svnu<CR>:edit<CR>
" map <F4> :w<CR>:!tmux send-keys -t left 'svnu' Enter <CR><CR>:edit<CR>
" map <F5> :w<CR>:!tmux send-keys -t left 'svnc' Enter <CR><CR>

" to set the window title in screen or tmux (?)
" if &term == "screen"
" 	set t_ts=k
" 	set t_fs=\
" 	endif
" if &term == "screen" || &term == "xterm"
" 	set title
" endif

" autocmd BufEnter * let &titlestring = "vim " . expand("%:t") . " " . expand("%:h")
autocmd BufEnter * let &titlestring = expand("%:t")

" command completion
"set wildchar=<Tab>
"set wildmenu
"set wildmode=list:longest,full
" set wildchar=<Tab> wildmenu wildmode=full " show list on tab (?)

" cursor line and column
"hi CursorLine cterm=NONE ctermbg=DarkMagenta ctermfg=white guibg=darkred guifg=white " DarkRed
hi CursorLine cterm=NONE ctermbg=black ctermfg=lightblue guibg=darkred guifg=white " DarkRed
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
set cursorline
"set cursorcolumn

" set textwidth=60 " when formatting text

" allow enter to insert line below and stay in navigation (shift enter for above)
" disabled because it interferes with :cwindow and enter to go to error
"map <CR> o<Esc>k
"map <S-Enter> O<Esc>j

" quick hack for matlab script edit and execute current file
" map <F5> :w<CR>:!tmux send-keys -t right '%:r' Enter <CR><CR>
" quick hack for matlab script edit and execute a fixed file
" map <F5> :w<CR>:!tmux send-keys -t right 'test_modes' Enter <CR><CR>

" search path for "gf", goto file
"set suffixesadd=.m

" change command beginning from : to ;, : still works
nnoremap ; :

" for latex-suite
"filetype plugin on " load when opening *.tex files
"set grepprg=grep\ -nH\ $*
"filetype indent on
"let g:tex_flavor='latex'

"function! Msend()
	"silent !tmux load-buffer -b 0 /home/dkuettel/.tmp.tmux.vim.matlab.execute
	"silent !tmux paste-buffer -b 0 -t 1
	"redraw!
"endfunction

"function! Mtest()
	"let line = getline('.')
	"call writefile([line],"/home/dkuettel/.tmp.tmux.vim.matlab.execute","")
	"call Msend()
"endfunction

"function! Mtest2() range
	"execute ":'<,'>w! /home/dkuettel/.tmp.tmux.vim.matlab.execute"
	"call Msend()
"endfunction

"map <leader>m :call Mtest() <CR>
"vmap <leader>m :call Mtest2() <CR>
"map <leader>l :call Msend() <CR>

"set runtimepath^=~/.vim/bundle/ctrlp.vim
"let g:ctrlp_cmd = 'CtrlPMixed'
"let g:ctrlp_root_markers = ['.ctrlp']
"let g:ctrlp_prompt_mappings = {'PrtClearCache()': ['<c-q>']}
map <C-[> :CtrlPBuffer<CR>
"let g:ctrlp_extensions = ['tag']

" solarized theme
syntax enable
set background=dark " the plugin considers dark the default, and it should fit with invertable colors
"let g:solarized_termtrans=1 " was necessary for putty to work
let g:solarized_termcolors=16 " 16 is better if set right, 256 is the compatible fixed color mode
let g:solarized_visibility="normal" " set list to see nonprint characters
colorscheme solarized

" quite nice and lightweight
nmap <Leader>bb :ls<CR>:buffer<Space>
" still it would be nicer to have it like easy motion with letters instead of number, and smarter sorting?

"let g:syntastic_cpp_checkers=['gcc']
"let g:syntastic_cpp_compiler_options='-Wall'

" using autosave bundle
let g:auto_save = 1
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode

" matches trailing white spaces and highlights them as an error
"match ErrorMsg '\s\+$'

set foldmethod=indent
set nofoldenable

" show trainling whitespaces
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces#Using_the_list_and_listchars_options
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" find tags with ctrlp
nnoremap <leader>. :CtrlPTag<cr>

" recompute ctags for select projects
" todo this matches only py files in src/nn, not further down in the folders
" todo probably more to exclude as well, see zsh history on staging machine
autocmd BufWritePost /home/kuettel/src/nn/*.py silent !ctags -f /home/kuettel/src/nn/tags --exclude=libs -R /home/kuettel/src/nn

" always keep some context lines visible
set scrolloff=8

" vim powerline
"set rtp+=~/.local/lib/python2.7/site-packages/powerline/bindings/vim
"python from powerline.vim import setup as powerline_setup
"python powerline_setup()
"python del powerline_setup
set laststatus=2 " so the status line (powerline) is always shown
