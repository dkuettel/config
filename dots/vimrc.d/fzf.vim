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


function! s:SelectSymbol() abort
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
        \ --delimiter='\t| '
        \ --with-nth=1,2,4 --nth=1,3
        \ --no-clear
        \ > fzf-selection
    redraw!
    call s:SelectSymbol()
endfunction


function! NavAllFiles() abort
    silent !fzf
        \ --expect=enter,ctrl-t,ctrl-v,ctrl-s,ctrl-c
        \ --preview='head --lines=$FZF_PREVIEW_LINES {}'
        \ --no-clear
        \ > fzf-selection
    redraw!
    call s:SelectFile()
endfunction


function! NavProjectFiles() abort
    silent !./.list-files | fzf
        \ --expect=enter,ctrl-t,ctrl-v,ctrl-s,ctrl-c
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
        \ --preview="sed -n '{2},+20p' {1}"
        \ --preview-window=top
        \ --no-clear
        \ > fzf-selection
    redraw!
    call s:SelectLine()
endfunction


map ,s :call NavProjectSymbols()<cr>
map ,F :call NavAllFiles()<cr>
map ,f :call NavProjectFiles()<cr>
map ,b :call NavBuffers()<cr>
map ,l :call NavLines()<cr>
