
# from looking at plugins/omz/lib/completion.zsh
# TODO but some of that is also in other places
# when understood, merge

unsetopt menu_complete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end

# TODO some things still work differently from when we use omz
# ls funny<tab> doesnt work for a file something.funny, only completes from the beginning?

zstyle ':completion:*:*:*:*:*' menu select

# TODO shift-tab not working right now, saw it in keybindings
bindkey "${terminfo[kcbt]}" reverse-menu-complete
bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete

# TODO zsh/complist module
# compinstall to load, automatically? not sure if that is all here now
