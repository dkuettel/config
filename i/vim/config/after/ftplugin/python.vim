setlocal
    \ tabstop=4 softtabstop=4 shiftwidth=4
    \ expandtab smarttab autoindent copyindent
    \ textwidth=0
    \ indentexpr= indentkeys=

" TODO should check if already set? this is run on every python file
" mappings further down are buffer-local and need to be run everytime I think
" but the drafty versions for functions maybe not

function! s:add(args) abort
    let l:winview = winsaveview()
    normal! gg
    " todo might not be the safest place to put
    " isort complains (maybe) if its above future? but still fixes it
    " what if currently not parseable? happen another time?
    " can we also make function local import?
    execute "normal! o" . a:args
    call winrestview(l:winview)
    " todo doesnt quite restore cursor and everything?
    " not sure if because of reformat or insert
    " seems like its both, it's not tracking the text
    normal ==
endfunction


" we reuse the same buffer for interactive fzf
let s:fzf_buffer = nvim_create_buf(v:false, v:true)


" whole fzf interactive copied from vimminent for testing
function! s:interactive(command, callback) abort
    " run fzf in a floating window
    " (asynchronous, but you are not meant to leave the window
    " by any means other than exiting fzf)

    let fzf = { 'callback': function(a:callback) }

    function! fzf.on_exit(id, code, ...)
        close
        call self.callback()
    endfunction

    " make floating window 'fullscreen'
    let opts = {
        \ 'relative': 'cursor',
        \ 'anchor': 'NW', 'row': 0, 'col': 0,
        \ 'width': &columns, 'height': &lines,
        \ 'style': 'minimal',
        \ }
    let win = nvim_open_win(s:fzf_buffer, v:true, opts)

    " default floating windows are inverted color
    setlocal winhighlight=Normal:Normal

    " termopen needs nomodified, or it will refuse
    setlocal nomodified

    call termopen(a:command, fzf)
    startinsert

endfunction


function! s:InsertFromFzf() abort
    if filereadable("fzf-selection")
        let l:reply = readfile("fzf-selection")
        call delete("fzf-selection")
        if len(l:reply) == 2
            let [l:action; l:selection] = l:reply
            call s:add(l:selection[0])
        endif
    endif
endfunction


function! SelectImportFromFzf() abort
    call s:interactive("pdocs list-imports | fzf
        \ --expect=enter,ctrl-c
        \ --color=border:-1
        \ --no-clear
        \ > fzf-selection",
        \ 's:InsertFromFzf')
endfunction


" todo probably put it on a shortcut
" also for in insert mode?
" dont forget cltr-f gives you vim power in edit line
command -nargs=1 Gi call s:add("<args>")
command SelectImportFromFzf call SelectImportFromFzf()

" todo ctrl-i is tab, cannot be distinguished
" similar ctrl-m and enter the same I think
nmap <buffer> <c-k> :Gi 
" TODO completely forgot about ,k, starting using it more, make it faster
" TODO currently trying it from pdocs
"nmap <buffer> ,k :SelectImportFromFzf<cr>
imap <buffer> <c-k> <c-o>:Gi <c-r><c-w>

" NOTE triggered as soon as typing an non-keyword character (see iskeyword), not tab or something
" NOTE if it stops working, it could be something remapped <enter>
iabbrev <buffer> ifmain if __name__ == "__main__":
iabbrev <buffer> nie() NotImplementedError()
iabbrev <buffer> ## # TODO
iabbrev <buffer> definit def __init__(self):<enter><tab>super().__init__()
