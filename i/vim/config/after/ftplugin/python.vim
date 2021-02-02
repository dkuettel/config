setlocal
    \ tabstop=4 softtabstop=4 shiftwidth=4
    \ expandtab smarttab autoindent copyindent
    \ textwidth=0
    \ indentexpr= indentkeys=

" todo tried a local mapping
" needs to be made local, and not autocommand
" because here we are already in type file
"autocmd FileType python inoremap <buffer> ' "
"autocmd FileType python inoremap <buffer> " '


function s:add(args) abort
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

" todo probably put it on a shorcut
" also for in insert mode?
" dont forget cltr-f gives you vim power in edit line
command -nargs=1 Gi call s:add("<args>")

" todo ctrl-i is tab, cannot be distinguished
" similar ctrl-m and enter the same I think
nmap <c-k> :Gi 
imap <c-k> <c-o>:Gi 
