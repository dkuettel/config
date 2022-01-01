
" https://github.com/junegunn/vim-plug
" PlugUpdate to update plugins
" PlugClean remove unlisted plugins
" PlugUpgrade upgrade Plug itself
" PlugDiff shows changes of last update
let g:plug_window="tab"
if has('nvim')
    call plug#begin('~/.local/share/nvim/plugged')
else
    call plug#begin('~/.vim/plugged')
endif

    Plug 'altercation/vim-colors-solarized'
    Plug 'easymotion/vim-easymotion'
    "Plug 'psf/black' " should work, but we want custom combination of black and isort currently
    Plug 'sbdchd/neoformat' " alternative to psf/black above, also works for isort now
    Plug 'airblade/vim-gitgutter'
    Plug 'scrooloose/nerdcommenter'

    if has('nvim')
        Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
    else
        " nvim can do it natively
        " vim not, they never merged a patch for that
        " maybe could be done easier and with no plugin
        Plug 'tmux-plugins/vim-tmux-focus-events' " might be native in vim8?
    endif

    Plug 'tpope/vim-fugitive'

    Plug '~/config/i/vim/config/vimminent'
    Plug '~/config/i/pdocs/pdocs/nvim'

call plug#end()


""" solarized
" note do this before later we change specific colors, otherwise they are overwritten
" todo why does it not flip dark/light by just changing the terminals colors?
" todo not sure still if we are really using 16 color (only)? vim setting, tmux settings?
set background=dark " the plugin considers dark the default, and it should fit with invertable colors
let g:solarized_termcolors=16 " 16 is better if set right, 256 is the compatible fixed color mode
let g:solarized_visibility="normal" " set list to see nonprint characters
silent! colorscheme solarized
" note we reset them later in this file
hi SignColumn cterm=NONE ctermbg=0 ctermfg=10
hi DiffAdd cterm=NONE ctermbg=0 ctermfg=10
hi DiffChange cterm=NONE ctermbg=0 ctermfg=10
hi DiffDelete cterm=NONE ctermbg=0 ctermfg=10
highlight SpecialKey NONE
highlight NonText None


""" easymotion
" todo: light weight version that only support f and f2?
let g:EasyMotion_do_mapping = 0
nmap s <Plug>(easymotion-overwin-f)
nmap S <Plug>(easymotion-overwin-f2)
"nmap s <Plug>(easymotion-bd-f)
"nmap S <Plug>(easymotion-bd-f2)
hi EasyMotionShade cterm=none ctermfg=10 ctermbg=none
hi EasyMotionTarget cterm=bold ctermfg=3 ctermbg=none
hi EasyMotionTarget2First cterm=bold ctermfg=3 ctermbg=none
hi EasyMotionTarget2Second cterm=none ctermfg=4 ctermbg=none
" todo the overwin command currently ignores First and Second :/ only the easymotion-bd-f uses it nicely
" its a bug see https://github.com/easymotion/vim-easymotion/issues/364


""" neoformat
"nnoremap == :Black<cr> " Plugin disabled currently, see above
" neoformat is buggy:
" - multiple formatters in a sequence can cut off the file at the end
"   see https://github.com/sbdchd/neoformat/pull/235 and https://github.com/sbdchd/neoformat/issues/256
" - the working directory is _changed_ to the file being formatted, that makes it hard to discover configurations or venvs
"   see https://github.com/sbdchd/neoformat/issues/47 (merged unfortunately)
" as a workaround:
" - use a single executable that chains isort and black
" - set a env variable when starting vim for the formatter to use to discover a venv or settings
" TODO I dont get anymore a message about changes needed
let g:neoformat_enabled_python = ['isort_and_black']
let g:neoformat_only_msg_on_error = 0
"let g:neoformat_try_formatprg = 1
let $vim_project_folder = $PWD
let g:neoformat_python_isort_and_black = {
        \ 'exe': 'some-isort-and-black',
        \ 'args': [],
        \ 'stdin': 1,
    \ }
let g:neoformat_basic_format_align = 0
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1
map == :Neoformat<enter>


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


"" semshi
" todo maybe exclude local, speed? too many colors?
let g:semshi#excluded_hl_groups = []
" todo potentially slow?
let g:semshi#always_update_all_highlights = v:true
" problem: if semshi would use the default keyword for its highlights, we didn't have to workaround with autocmds
function! SemshiCustomColors()
    " vim python highlights
    hi pythonComment ctermfg=10 cterm=italic
    hi pythonStatement ctermfg=2 cterm=italic
    hi pythonFunction ctermfg=4
    hi pythonInclude ctermfg=10 cterm=italic
    hi pythonString ctermfg=10
    hi pythonQuotes ctermfg=10
    hi pythonOperator ctermfg=2 cterm=italic
    hi pythonKeyword ctermfg=2 cterm=italic
    hi pythonConditional ctermfg=2 cterm=italic
    hi pythonDecorator ctermfg=4
    hi pythonDecoratorName ctermfg=10 cterm=italic

    " semshi highlights
    " todo missing different colors for type hints
    " todo missing different colors for kw name vs kw value
    hi semshiLocal ctermfg=4 cterm=none
    hi semshiGlobal ctermfg=4 cterm=none
    hi semshiImported ctermfg=2 cterm=none
    hi semshiParameter ctermfg=4 cterm=underline
    hi semshiParameterUnused ctermfg=4 cterm=strikethrough
    hi semshiFree ctermfg=10 cterm=bold
    hi semshiBuiltin ctermfg=2 cterm=italic
    hi semshiAttribute ctermfg=4 cterm=none
    hi semshiSelf ctermfg=none cterm=italic
    hi semshiUnresolved ctermfg=10 ctermbg=8 cterm=strikethrough
    hi semshiSelected ctermfg=14 ctermbg=0 cterm=none
    hi semshiErrorSign ctermfg=1 ctermbg=0 cterm=none
    sign define semshiError text=E> texthl=semshiErrorSign
    hi semshiErrorChar ctermfg=10 ctermbg=8 cterm=strikethrough
endfunction
autocmd FileType python call SemshiCustomColors()


""" vim diff colors
" todo cursorline has same background color, vim seems to show overlap with underline (line on marked diff) which hides DiffText
" note we set them before above with solarized
hi DiffAdd ctermfg=none ctermbg=0 cterm=none
"hi DiffDelete ctermfg=10 ctermbg=0 cterm=none
hi DiffDelete ctermfg=8 ctermbg=0 cterm=none
hi DiffChange ctermfg=none ctermbg=0 cterm=none
hi DiffText ctermfg=none ctermbg=0 cterm=underline


""" fugitive
nmap ,gs :tab Git<cr>
" colors
" currently cannot change diff*, which are only for status diff, maybe one day split
" would be nice for signs
"hi GitGutterAdd ctermfg=10
"hi GitGutterChange ctermfg=10
"hi GitGutterDelete ctermfg=10
" if separate
"hi diffRemoved ctermfg=10
"hi diffChanged ctermfg=14
"hi diffAdded ctermfg=7
" joint for now high contrast
"hi GitGutterAdd ctermfg=7
"hi GitGutterChange ctermfg=14
"hi GitGutterDelete ctermfg=10
" joint for now low contrast
hi GitGutterAdd ctermfg=14
hi GitGutterChange ctermfg=14
hi GitGutterDelete ctermfg=11


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
