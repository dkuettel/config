
""" install vim-plug
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
" https://github.com/junegunn/vim-plug
if has('nvim')
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
        silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    endif
else
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    endif
endif


" https://github.com/junegunn/vim-plug
if has('nvim')
    call plug#begin('~/.local/share/nvim/plugged')
else
    call plug#begin('~/.vim/plugged')
endif

    Plug 'easymotion/vim-easymotion'
    Plug 'altercation/vim-colors-solarized'
    "Plug 'psf/black' " todo https://github.com/psf/black/pull/978 when merged could fix the view reset problems
    Plug 'sbdchd/neoformat'
    Plug 'airblade/vim-gitgutter'
    Plug 'scrooloose/nerdcommenter'
    Plug 'mattboehm/vim-unstack'

    if !has('nvim')
        " nvim can do it natively
        " vim not, they never merged a patch for that
        " maybe could be done easier and with no plugin
        Plug 'tmux-plugins/vim-tmux-focus-events'
    endif

    "Plug 'tmux-plugins/vim-tmux-focus-events' " probably in vim8 native?
    "Plug 'tpope/vim-fugitive'
    "Plug 'davidhalter/jedi-vim'
    "Plug 'vim-syntastic/syntastic'
    "Plug 'vim-python/python-syntax'
    "Plug 'majutsushi/tagbar'

    Plug '~/toys/vimminent'
    Plug '~/toys/pdocs'

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
highlight SpecialKey NONE
highlight NonText None


""" black
" todo make it per filetype
" set equalprg=python3\ -m\ black\ --quiet\ -
" nnoremap <leader>= mc:%!python3 -m black --quiet -<cr>`c
"nnoremap == :Black<cr> " Plugin disabled currently, see above
let g:neoformat_enabled_python = ['black']
let g:neoformat_try_formatprg = 1
let g:neoformat_python_black = {
        \ 'exe': 'black',
        \ 'args': ['-', '--quiet', '--target-version=py37'],
        \ 'stdin': 1,
    \ }
let g:neoformat_basic_format_align = 0
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1
map == :Neoformat<cr>


""" gitgutter
" https://github.com/airblade/vim-gitgutter
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
" https://github.com/scrooloose/nerdcommenter
" adds many ,c-something shortcuts
" maybe remove unneeded ones
" ,cc ,cu ,c<space> ,ci are interesting
let g:NERDDefaultAlign = 'left'


""" unstack for python stacktraces
" https://github.com/mattboehm/vim-unstack
" todo doesn't setup nicely, still well maintained?
" it's just the parsing that matters, maybe easy to do more lightweight?
let g:unstack_populate_quickfix=1
vnoremap ,pt :<c-u>call unstack#Unstack(visualmode())<cr>
" improve:
" make it parse and open from trace directly
" make it maybe do tabs (if clean vim session)
" make it deal with docker vs realworld paths
" easy way to see actual exception for context?
" deal with moved code because of fixing?
" below seems to have an easy configuration to make quickfix understand " tracebacks?
" https://vi.stackexchange.com/questions/5110/quickfix-support-for-python-tracebacks


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


""" vimminent
let g:vimminent_default_mappings = 1


""" pdocs
let g:pdocs_default_mappings = 1
