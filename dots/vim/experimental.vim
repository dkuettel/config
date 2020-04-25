" change case of previous word in insert mode
imap <c-u> <esc>mmvB~`ma

""" navigate splits
" default vim <c-w> h/j/k/l
"nnoremap <c-j> <c-w>j
"nnoremap <c-k> <c-w>k
"nnoremap <c-l> <c-w>l
"nnoremap <c-h> <c-w>h

" consider: cterm=bold, underline, italic, inverse
" solarized style
" problem: without fg its considered low priority. a syntax highlight that specifies bg will overwrite bg here
hi CursorLine cterm=NONE ctermbg=0 ctermfg=NONE
hi CursorColumn cterm=NONE ctermbg=0 ctermfg=NONE
" using a 256 color, not solarize-invertible
" https://jonasjacek.github.io/colors/
" options: 45, 51, 81, 117, 123, 153, 159, 189, 159
"hi CursorLine cterm=NONE ctermbg=45 ctermfg=NONE
"hi CursorColumn cterm=NONE ctermbg=45 ctermfg=NONE
set cursorline nocursorcolumn
nnoremap ,x :set cursorline!<cr>
nnoremap ,X :set cursorcolumn!<cr>

" have cursorline/column only in active window
" problem, only do when actually activated (,x)
augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline nocursorcolumn
    autocmd WinLeave * setlocal nocursorline nocursorcolumn
augroup END

set virtualedit=all

" to debug highlights
" add %{SyntaixItem()} to statusline
"function! SyntaxItem()
"    let s = ""
"    for id in synstack(line("."), col("."))
"        let tid = synIDtrans(id)
"        if tid == id
"            let s = s . " >" . synIDattr(id, "name")
"        else
"            let s = s . " >" . synIDattr(id, "name") . "=" . synIDattr(tid, "name")
"        endif
"    endfor
"    return s
"endfunction

set laststatus=2
set statusline=[%{winnr()}]\ %q%h%w%f%m%r%=%{mode(1)}\ %p%%\ @%l:%v
hi StatusLine cterm=italic,bold ctermbg=15 ctermfg=10
hi StatusLineNC cterm=italic,inverse ctermbg=NONE ctermfg=NONE

function! CustomTabline()
    let s = ''
    for i in range(tabpagenr('$'))
        if i+1 == tabpagenr()
            let s.= '%#TabLineSel#'
        else
            let s.= '%#TabLine#'
        endif
        let s .= '/'.(i+1).' '
    endfor
    let s.= '%#TabLine#'
    return s
endfunction
set tabline=%!CustomTabline()
hi TabLine cterm=inverse
hi TabLineSel cterm=bold ctermbg=15 ctermfg=10
hi TablineFill cterm=inverse

" execute current line / visual as vim command
map ,v yy:@"<enter>
vmap ,v y:@"<enter>

set showcmd

" navigate windows
" map ,w <c-w> could also be interesting
" but also easymotion is convenient to switch between windows
map ,1 1<c-w>w
map ,2 2<c-w>w
map ,3 3<c-w>w
map ,4 4<c-w>w
map ,5 5<c-w>w
map ,6 6<c-w>w

" clear window for external commands, easier to read especially for fugitive
"set shell=~/config/bin/vim_shell.sh


" todo could be interesting to have different cursor shapes and colors for normal and insert mode
" see https://www.reddit.com/r/vim/comments/8se9ug/changing_cursor_in_different_modes_with_tmux/
" seems to just work now in neovim

" tab navigation
" caveat: t is a default mapping for 'until'
map tt :tab split<enter>
map tT <c-w>T
map tc :tabclose<enter>
map tp :tabprevious<enter>
map tn :tabnext<enter>
map to :tabonly<enter>
for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
    " map t# #gt
    execute "map t" . i . " " . i . "gt"
    " map tm# :tabmove #-1<enter>
    execute "map tm" . i . " :tabmove " . (i-1) . "<enter>"
endfor

" make ctrl-d and ctrl-u move one line (nice for scrolling)
set scroll=1

" use arrow up and down like ctrl-d and ctrl-u with scroll 1 for easy browsing
map <Down> 1<c-d>
map <Up> 1<c-u>

" // to disable highlights again after search (any short clash here?)
map // :nohlsearch<enter>

" try easier pair parantheses & co typing
" https://github.com/jiangmiao/auto-pairs looks very good, but somehow big for what it is
" note: use <c-v> + ( or ) to type literally without mapping
" note: could also map (( instead of ( to have it only when you want it
" todo maybe only exit adjacent parantheses, like for ' and "
" todo maybe also delete if empty pair
" todo or generally create delete pairs together?
" todo typing ) in an unexpected place might move you to weird places
" todo also when adding for example list(...) later it doesnt work well
" todo doesnt work well when doing "isn't" or something like that
"inoremap ( ()<left>
"inoremap ) <esc>/)<enter>:nohl<enter>a
"inoremap { {}<left>
"inoremap } <esc>/}<enter>:nohl<enter>a
"inoremap [ []<left>
"inoremap ] <esc>/]<enter>:nohl<enter>a
"inoremap [ []<left>
"inoremap ] <esc>/]<enter>:nohl<enter>a
"inoremap <expr> ' getline('.')[col('.')-1] == "'" ? "<right>" : "''<left>"
"inoremap <expr> " getline('.')[col('.')-1] == '"' ? "<right>" : '""<left>'


" comment and duplicate (uses nerdcommenter, could be put there if good)
map ,cp ,cy`>p


" get pylint disabler from current quickfix entry
function! AddQuickfixPylintDisabler()
    let idx = getqflist({'idx': 0}).idx
    let error = getqflist({'items': 0}).items[idx-1].text
    let disabler = matchstr(error, '(\zs.*\ze)$')
    execute ':normal! A' . '  # pylint: disable=' . disabler
endfunction
nnoremap ,qfd :call AddQuickfixPylintDisabler()<enter>

" highlight active window
" todo could work, a bit aggressive?
" with true color probably more useful, less stark change
highlight NormalNC ctermbg=0
