
if exists("b:current_syntax")
    finish
endif

" now with 24bit colors could use fainter colors for more and more indentation?

syntax match todoSection "\v^[^- ].*:$"
syntax match todoTodo "\v^ *o \zs.*\ze$"
syntax match todoDone "\v^ *x \zs.*\ze$"
syntax match todoNow "\v^ *! \zs.*\ze$"
syntax match todoRunning "\v^ *r \zs.*\ze$"

if g:colors_name == "solarized"
    " original solarized (not 24bit)
    highlight link todoSection Folded
    highlight link todoTodo Identifier
    highlight link todoDone Comment
    highlight link todoNow Error
    highlight link todoRunning Statement

elseif g:colors_name == "gruvbox"
    highlight todoSection gui=underline,bold guifg=#3c3836 guibg=#ebdbb2
    highlight todoTodo gui=bold guifg=#3c3836
    highlight todoDone gui=strikethrough guifg=#928374
    highlight todoNow guifg=#fbf1c7 guibg=#b57614
    highlight todoRunning gui=italic guifg=#076678
endif

let b:current_syntax = "todo"
