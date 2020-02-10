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
"augroup CursorLineOnlyInActiveWindow
"    autocmd!
"    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline cursorcolumn
"    autocmd WinLeave * setlocal nocursorcolumn
"augroup END

set virtualedit=all

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

" execute current line as vim command
map ,v yy:@"<cr>

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


" tab navigation
" problem: T and t are default bindings for 'until'
map T :tab split<cr>
map tc :tabclose<cr>

" make ctrl-d and ctrl-u move one line (nice for scrolling)
set scroll=1
