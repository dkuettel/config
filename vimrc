source ~/config/vundle.vim

filetype on
filetype plugin on
filetype indent on " sleuth always sets this, I don't like it for python, i disable it for the python filetype specifically later

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
set showmatch " highlight matching braces
set backspace=indent,eol,start " allow backspacing over everything in insert mode

" navigate splits
" todo does it disable the redraw on ctrl-l?
nnoremap  <c-w>j " todo since I moved to vim 8 <c-j> on the first argument doesn't work anymore, had to actually use c-v c-j to make the character
nnoremap <c-j> <c-w>j " todo since I moved to vim 8 <c-j> on the first argument doesn't work anymore, had to actually use c-v c-j to make the character
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h
nmap ,rr :redraw!<cr>

" solarized
" todo why does it not flip dark/light by just changing the terminals colors?
set background=dark " the plugin considers dark the default, and it should fit with invertable colors
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
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab autoindent copyindent
"autocmd FileType cpp setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType cpp setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
autocmd FileType cu setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

" easymotion
nmap s <Plug>(easymotion-overwin-f)

" ctrlp
" note: ~/.cache/ctrlp saves a global cache
" :CtrlPClearAllCaches seems to delete most there
let g:ctrlp_working_path_mode = 0 " always base off initial working folder
let g:ctrlp_switch_buffer = 0 " don't switch between splits when selecting a file/buffer to open, stay on split, makes it easier to open same file in many splits
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:20'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_match_current_file = 1 " match files even when it's the current file
nnoremap <leader>. :CtrlPTag<cr>
nnoremap <leader>t :CtrlPBufTag<cr>
nnoremap <leader>b :CtrlPBuffer<cr>

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
set tags=./.tags " use this file local to vim working directory
" let g:easytags_file=./tags " todo correct?
let g:easytags_dynamic_files = 2 " use tag file path relative to vim working folder, not active buffer
set cpoptions+=d " use tag file path relative to vim working folder, not active buffer file
let g:easytags_auto_highlight = 1 " todo might slow down vim
" let g:easytags_opts = 1 " todo async call seems to not work yet, vim8 has built-in async call maybe instead
" let g:easytags_autorecurse = 1 " todo unfortunately does it also on autosave, not just :UpdateTags

" airline
set laststatus=2 " not sure if needed
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " show tab id
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_close_button = 0

" trying autosave and co
set autoread " autoread files if changed outside and not locally, on focus events, does not work out of the box in tmux vim
au FocusLost * :wa

" try undo tree
nnoremap <Leader>u :GundoToggle<CR>

" syntastic
" sudo -H pip install flake 8
" flake8 syntax python 2 vs 3 is decided when installing flake8
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" from marcin
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_quiet_messages = { "type": "style" } " remove all style warnings
"let g:syntastic_python_flake8_args='--ignore=E501,E225,E251,E231,W191'
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
" from me
let g:syntastic_auto_jump = 1
let g:syntastic_mode_map = {"mode":"passive"}
nmap <leader>sc :w<cr>:SyntasticCheck<cr>
nmap <leader>sr :SyntasticReset<cr>
nmap ]l :lnext<CR>
nmap [l :lprev<CR>

" kinda cool, useful?
inoremap jj <Esc>

" notes
" gi go to last insert mode in insert mode
" '' go to last insert mode

syntax on

let g:signify_vcs_list = [ 'git' ]
let g:signify_update_on_bufenter = 1 " also saves, too heavy?
let g:signify_update_on_focusgained = 1 " maybe also saves, too heavy?
" try shortcut for manual refresh, clashes a bit with <leader>g
nmap <leader>gu :SignifyRefresh<cr>

" open splits more naturally below and right
set splitbelow
set splitright

" try direct numbered selection of windows
map ,w1 :wincmd t<cr>
map ,w2 :wincmd t<cr>:wincmd w<cr>
map ,w3 :wincmd t<cr>:wincmd w<cr>:wincmd w<cr>
map ,w4 :wincmd t<cr>:wincmd w<cr>:wincmd w<cr>:wincmd w<cr>
map ,w5 :wincmd t<cr>:wincmd w<cr>:wincmd w<cr>:wincmd w<cr>:wincmd w<cr>
map ,w6 :wincmd t<cr>:wincmd w<cr>:wincmd w<cr>:wincmd w<cr>:wincmd w<cr>:wincmd w<cr>

" clear window for external commands, easier to read especially for fugitive
set shell=~/config/bin/vim_shell.sh

" should globally disable any automatic inserting of new lines for longs lines
set textwidth=0 wrapmargin=0

" trying out some new (tab) navigation
" remember: c-w } for tag in preview window
" remember: {tabid}gt to jump directly to a tab
map T :tab split<cr> " new tab, view on current buffer
map tc :tabclose<cr> " close current tab
" vim jedi goto commands
let g:jedi#goto_command = ''
nmap ,dd :call jedi#goto()<cr>zt " not sure if that is the best way, maybe there is a global setting for how it always centers on the cursor when you move around?
nmap ,dt :tab split<cr>,dd
nmap ,ds <c-w>s,dd
nmap ,dv <c-w>v,dd
nmap ,dp <c-w>} " alternative for preview on tag

" try dealing with long lines
set breakindent " visually breaks lines using the same indentation
let &showbreak = '  ↪ '  " characters to show on a continued line
set nowrap " do or don't viusally break linkes (does not change text)
map ,ww :set wrap!<cr> " toggle wrapping (on or off)

" try custom python import
function! Test_import()
pyfile ~/toys/test.vim.py
endfunc
nmap <c-i> :call Test_import()<cr>

let g:python_highlight_all = 1

" python debugging template
map ,pd oimport ipdb; ipdb.set_trace()<esc>
map ,pD Oimport ipdb; ipdb.set_trace()<esc>

" plugin vim-argwrap
let g:argwrap_tail_comma = 1 " python style commas even for the last argument
let g:argwrap_tail_comma_braces = '[{' " as above
nnoremap <silent> <leader>a :ArgWrap<CR>

" try to use a local find if it's there (faster, easier to configure there)
if filereadable('./.ctrlp.find')
	let g:ctrlp_use_caching = 0
	" note: annoyingly the command seems to not be used when %s is not in there
	let g:ctrlp_user_command = './.ctrlp.find %s'
endif

" tagbar toggle
nmap tt :TagbarToggle<cr>

nmap ,Gs :Gstatus<cr>

" camel-and-other-case motion (vundle plugin) mappings
map <silent> ccw <Plug>CamelCaseMotion_w
map <silent> ccb <Plug>CamelCaseMotion_b
map <silent> cce <Plug>CamelCaseMotion_e
omap <silent> cciw <Plug>CamelCaseMotion_iw
xmap <silent> cciw <Plug>CamelCaseMotion_iw

" easy surround = with spaces
nmap ,<space><space> i <esc>la <esc>

" try to use command line window for easier editing
nmap ; q:i
