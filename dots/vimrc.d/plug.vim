
""" install vim-plug
" todo only works for vim
" check https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
" and https://github.com/junegunn/vim-plug
" to see where to put it for neovim
" can use if has('nvim')
" neovim wants it at
" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif


" see https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')
    Plug 'easymotion/vim-easymotion'
    Plug 'altercation/vim-colors-solarized'
    Plug 'ambv/black'
    Plug 'airblade/vim-gitgutter'
    Plug 'scrooloose/nerdcommenter'
    "Plug 'tmux-plugins/vim-tmux-focus-events' " probably in vim8 native?
    "Plug 'tpope/vim-fugitive'
    "Plug 'davidhalter/jedi-vim'
    "Plug 'vim-syntastic/syntastic'
    "Plugin 'vim-python/python-syntax'
    "Plugin 'majutsushi/tagbar'
call plug#end()


""" easymotion
" todo: light weight version that only support f and f2?
let g:EasyMotion_do_mapping = 0
nmap s <Plug>(easymotion-overwin-f)
nmap S <Plug>(easymotion-overwin-f2)


""" solarized
" todo why does it not flip dark/light by just changing the terminals colors?
" todo not sure still if we are really using 16 color (only)? vim setting, tmux settings?
set background=dark " the plugin considers dark the default, and it should fit with invertable colors
let g:solarized_termcolors=16 " 16 is better if set right, 256 is the compatible fixed color mode
let g:solarized_visibility="normal" " set list to see nonprint characters
silent! colorscheme solarized
hi SignColumn cterm=NONE ctermbg=0 ctermfg=10
hi DiffAdd cterm=NONE ctermbg=0 ctermfg=10
hi DiffChange cterm=NONE ctermbg=0 ctermfg=10
hi DiffDelete cterm=NONE ctermbg=0 ctermfg=10


""" black
" todo make it per filetype
" set equalprg=python3\ -m\ black\ --quiet\ -
" nnoremap <leader>= mc:%!python3 -m black --quiet -<cr>`c
nnoremap == :Black<cr>


""" gitgutter
" see https://github.com/airblade/vim-gitgutter
" note: using updatetime for updates
" not sure how to use it to stage and commit
"let g:gitgutter_enabled = 0
"let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0
" defaults:
" ]c [c to move between hunks
" ,hp ,hs ,hu for preview, stage, undo hunks
map ,gt :GitGutterToggle<cr>


""" nerdcommenter
" see https://github.com/scrooloose/nerdcommenter
" adds many ,c-something shortcuts
" maybe remove unneeded ones
" ,cc ,cu ,c<space> ,ci are interesting


""" fugitive
"nmap ,Gs :Gstatus<cr>


""" vim-jedi
"let g:jedi#goto_command = ''
"nmap ,dd :call jedi#goto()<cr>zt
"nmap ,dt :tab split<cr>,dd
"nmap ,ds <c-w>s,dd
"nmap ,dv <c-w>v,dd
"nmap ,dp <c-w>}


""" tagbar toggle
"nmap tt :TagbarToggle<cr>

