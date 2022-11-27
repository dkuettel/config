" TODO is this still the right thing to do? a) .vim, and b) in after?

setlocal
    \ tabstop=4 softtabstop=4 shiftwidth=4
    \ expandtab smarttab autoindent copyindent
    \ textwidth=0
    \ indentexpr= indentkeys= cinkeys=
    \ formatoptions=

" NOTE triggered as soon as typing an non-keyword character (see iskeyword), not tab or something
" if it stops working, it could be something remapped <enter> or <space>
" ctrl-] in insert mode triggers completion without <enter> or <space>
" can also be used in those breaking remaps
" often it's the remapping for autocompletion plugins on <enter>
iabbrev <buffer> ifmain if __name__ == "__main__":
iabbrev <buffer> nie() NotImplementedError()
iabbrev <buffer> ## # TODO
iabbrev <buffer> #$ # NOTE
iabbrev <buffer> definit def __init__(self):<enter><tab>super().__init__()
iabbrev <buffer> #i # pyright: ignore
iabbrev <buffer> O[ Optional[

" TODO trying some shortcuts prefixed with shift-tab, shift-tab is never used, right?
imap <buffer> <s-tab>o Optional[
imap <buffer> <s-tab>b breakpoint()

" TODO trying some -... shortcuts in normal mode for inserting easy stuff
nmap <buffer> -i A  # pyright: ignore<esc>
nmap <buffer> -b obreakpoint()<esc>
