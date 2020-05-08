
if exists("b:current_syntax")
    finish
endif

syntax match todoSection "\v^[^- ].*:$"
highlight link todoSection Folded

syntax match todoTodo "\v^ *o .*$"
highlight link todoTodo Identifier

syntax match todoDone "\v^ *x .*$"
highlight link todoDone Comment

syntax match todoNow "\v^ *! .*$"
highlight link todoNow Error

syntax match todoRunning "\v^ *r .*$"
highlight link todoRunning Statement

let b:current_syntax = "todo"
