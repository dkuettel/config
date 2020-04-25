""" autosave and -read
" interesting events:
" InsertLeave, TextChanged, CursorHold
" TextChangedI, CursorHoldI
" FocusGained, FocusLost
" (needs events configured coming from the terminal or tmux, check if that works)
set autoread
set updatetime=500
augroup autosave
    autocmd!
    autocmd InsertLeave,TextChanged * silent! w
    autocmd CursorHold,CursorHoldI * silent! update
    autocmd FocusLost * silent! wa
    autocmd FocusGained * silent! checktime
augroup END
" problems:
" should not run :w when buffer has no file
" silent! surpressed that error messages
" but would be nicer not to try at all
" CursorHoldI doesn't seem to trigger update currently
