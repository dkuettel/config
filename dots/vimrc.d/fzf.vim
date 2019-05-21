function! s:OpenAction(action) abort
    if a:action == "enter"
        return 1
    elseif a:action == "ctrl-t"
        execute "tab split"
        return 1
    elseif a:action == "ctrl-v"
        execute "vsplit"
        return 1
    elseif a:action == "ctrl-s"
        execute "split"
        return 1
    elseif a:action == "ctrl-c"
        return 0
    else
        throw "unknown action ".a:action
    endif
endfunction


function! s:SelectSymbol_FormatTags() abort
    let l:selection = readfile("fzf-selection")
    call delete("fzf-selection")
    let l:action = l:selection[0]
    let [l:symbol, l:file, l:location] = split(l:selection[1], "\t")
    let l:location = split(l:location, ";")[0]
    if s:OpenAction(l:action)
        execute "edit" l:file
        execute "normal!" l:location."Gzz"
    endif
endfunction


function! s:SelectSymbol_FormatVimFzf() abort
    let l:selection = readfile("fzf-selection")
    call delete("fzf-selection")
    let l:action = l:selection[0]
    let [l:symbol, l:cfile, l:file, l:location] = split(l:selection[1], "\t")
    if s:OpenAction(l:action)
        execute "edit" l:file
        execute "normal!" l:location."Gzz"
    endif
endfunction


function! s:SelectFile() abort
    let [l:action, l:file] = readfile("fzf-selection")
    call delete("fzf-selection")
    if s:OpenAction(l:action)
        execute "edit" l:file
    endif
endfunction


function! s:SelectBuffer() abort
    call delete("fzf-list")
    let [l:action, l:selection] = readfile("fzf-selection")
    let l:buffer = split(l:selection, " ")[0]
    call delete("fzf-selection")
    if s:OpenAction(l:action)
        execute "buffer" l:buffer
    endif
endfunction


function! s:SelectLine() abort
    let [l:action, l:selection] = readfile("fzf-selection")
    call delete("fzf-selection")
    let l:parsed = split(l:selection, ":")
    let l:file = l:parsed[0]
    let l:line = l:parsed[1]
    if s:OpenAction(l:action)
        execute "edit" l:file
        execute "normal!" l:line."Gzz"
    endif
endfunction


function! NavProjectSymbols() abort
    silent !./.list-symbols | fzf
        \ --expect=enter,ctrl-t,ctrl-v,ctrl-s,ctrl-c
        \ --delimiter='\t'
        \ --ansi
        \ --color=border:-1
        \ --with-nth=1,2 --nth=1
        \ --preview='tail --lines=+{4} {3} | head --lines=$FZF_PREVIEW_LINES'
        \ --preview-window=top:30\%
        \ --no-clear
        \ > fzf-selection
    redraw!
    call s:SelectSymbol_FormatVimFzf()
endfunction


function! NavAllFiles() abort
    silent !fzf
        \ --expect=enter,ctrl-t,ctrl-v,ctrl-s,ctrl-c
        \ --color=border:-1
        \ --preview='head --lines=$FZF_PREVIEW_LINES {}'
        \ --no-clear
        \ > fzf-selection
    redraw!
    call s:SelectFile()
endfunction


function! NavProjectFiles() abort
    silent !./.list-files | fzf
        \ --expect=enter,ctrl-t,ctrl-v,ctrl-s,ctrl-c
        \ --color=border:-1
        \ --preview='head --lines=$FZF_PREVIEW_LINES {}'
        \ --no-clear
        \ > fzf-selection
    redraw!
    call s:SelectFile()
endfunction


function! NavBuffers() abort

    let l:is_valid = 'buflisted(v:val) && getbufvar(v:val, "&filetype") != "qf"'
    let l:entries = filter(range(1, bufnr("$")), l:is_valid)
    call map(l:entries, 'v:val." ".bufname(v:val)')
    call writefile(l:entries, "fzf-list")

    silent !cat fzf-list | fzf
        \ --expect=enter,ctrl-t,ctrl-v,ctrl-s,ctrl-c
        \ --delimiter=' '
        \ --nth=2
        \ --color=border:-1
        \ --preview='head --lines=$FZF_PREVIEW_LINES {2}'
        \ --no-clear
        \ --sync
        \ > fzf-selection
    redraw!
    call s:SelectBuffer()

endfunction


function! NavLines() abort
    silent !grep --with-filename --line-number '' $(./.list-files) | fzf
        \ --expect=enter,ctrl-t,ctrl-v,ctrl-s,ctrl-c
        \ --delimiter=':'
        \ --color=border:-1
        \ --preview="cat <(for i ($(seq 1 15)) echo) {1} | sed -n '{2},+30p'"
        \ --preview-window=top
        \ --no-clear
        \ > fzf-selection
    redraw!
    call s:SelectLine()
endfunction


" todo
" works as a concept
" but still need a good way to control what exactly to use (full, last part only, ...)
" and preview could better be docstring, and/or function signature
" plus now there are ansi colorcodes there that we should to remove
" two or multistep could be a solution?
" we also want to search not just local symbols but also project symbols
" could rely on not list-symbols but on introspection as in doc.py
" would also be nice to show signature when back in editor (preview window?)
function! InsertSymbol() abort
    silent !./.list-symbols | fzf
        \ --expect=enter,ctrl-c
        \ --delimiter='\t'
        \ --ansi
        \ --with-nth=1,2 --nth=1
        \ --preview='tail --lines=+{4} {3} | head --lines=$FZF_PREVIEW_LINES'
        \ --preview-window=top:30\%
        \ --no-clear
        \ > fzf-selection
    redraw!
    let l:selection = readfile("fzf-selection")
    call delete("fzf-selection")
    let l:action = l:selection[0]
    let [l:symbol, l:cfile, l:file, l:location] = split(l:selection[1], "\t")
    if l:action == "enter"
        execute "normal" "i".l:symbol
    endif
endfunction


map ,s :call NavProjectSymbols()<cr>
map ,F :call NavAllFiles()<cr>
map ,f :call NavProjectFiles()<cr>
map ,b :call NavBuffers()<cr>
map ,l :call NavLines()<cr>
imap <c-n> <esc>:call InsertSymbol()<cr>
