
## prompt
# see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
# for colors:
#   http://ethanschoonover.com/solarized
#   http://www.zovirl.com/2011/07/22/solarized_cheat_sheet/
# todo see 'man zshzle' for reporting the current vim mode
# todo could use 'timeout --kill-after=0.01s 0.01s cmd' to stop git info when it takes too long on a slow filesystem
# todo checkout vcs info from zsh (see yves)
# todo could also use tmux pane titles for that information?
# todo show vim-mode in prompt? or on caret? (color?)
setopt PROMPT_SUBST # expand $ in prompt at show time
PROMPT='
%(?,,%F{1}%Sexit code = %?%s%f
)
%K{0}%F{14}%B%~%b%f ($(git symbolic-ref --short HEAD 2>/dev/null)) %F{10}%*%f %(1j,%F{1}%j&%f,) %E%k
> '

## vim-mode for zsh line editing
# see 'man zshzle'
bindkey -v
export KEYTIMEMOUT=1 # quicker reaction to mode change (might interfere with other things) (1=0.1seconds)
# add bindings to vim insert mode
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char # make backspace work after returning from command mode to insert mode
bindkey '^h' backward-delete-char # make ctrl-h work after returning from command mode to insert mode
# ctrl-r starts searching history backward
#bindkey '^r' history-incremental-search-backward
#bindkey '^r' znt-history-widget
#bindkey '^r' history-search-multi-word # todo not sure why I have to do it here, the plugin does it already, but it doesnt work
# edit command line in editor
#bindkey '^x^e' edit-command-line

## history
# try to make it "forever" and shared
# todo doesn't seem to update "live" yet ?
export HISTSIZE=1000000000
export SAVEHIST=1000000000
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_save_no_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history
