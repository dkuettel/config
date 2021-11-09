
# todo not sure about the right way to handle it
export LC_ALL=en_US.UTF-8

## prompt
# see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
# for colors:
#   http://ethanschoonover.com/solarized
#   http://www.zovirl.com/2011/07/22/solarized_cheat_sheet/
# todo see 'man zshzle' for reporting the current vim mode
# todo could use 'timeout --kill-after=0.01s 0.01s cmd' to stop git info when it takes too long on a slow filesystem
# todo checkout vcs info from zsh (see yves)
function zsh-prompt-git {
    sref=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ $? == 0 ]]; then
        echo -n '%F{3}('$sref
        stashed=$(git stash list 2>/dev/null | wc -l)
        if [[ $stashed != 0 ]]; then
            echo -n ', %F{1}'$stashed'-stashed%F{3}'
        fi
        echo -n ')%f '
    fi
}
setopt prompt_subst # expand $ in prompt at show time
export PS1='
%(?,,%F{1}%Sexit code = %?%s%f
)
%K{0}%F{4}%B %~%b%f $(zsh-prompt-git)%F{10}%*%f %F{5}(%m)%f %F{9}${VIRTUAL_ENV:+%B=venv=%b}%f %(1j,%F{1}%j&%f,) %E%k
%F{15}${${${KEYMAP:-main}/vicmd/N}/(main|viins)/I}>%f '
function zle-keymap-select() {
    zle reset-prompt
    zle -R
}
zle -N zle-keymap-select

## vim-mode for zsh line editing
# see 'man zshzle'
bindkey -v
export KEYTIMEOUT=1 # quicker reaction to mode change (might interfere with other things) (1=0.1seconds)
autoload up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search
bindkey -M vicmd 'k' up-line-or-beginning-search
autoload down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward
bindkey '^?' backward-delete-char # make backspace work after returning from command mode to insert mode
bindkey '^h' backward-delete-char # make ctrl-h work after returning from command mode to insert mode
#bindkey '^w' backward-kill-word
#bindkey -M vicmd '^r' history-incremental-search-backward # disabled because we use an antigen plugin
#bindkey -M viins '^r' history-incremental-search-backward # disabled because we use an antigen plugin
# unbind ',' to use it as a vim-style leader
bindkey -M vicmd -r ,
bindkey '^x^h' run-help
bindkey -M vicmd ',h' run-help
autoload edit-command-line
zle -N edit-command-line # todo autoload and zle -N, what?
bindkey '^x^e' edit-command-line
bindkey -M vicmd ',e' edit-command-line
# shortcut and then type pattern, to preview and finally insert matches
autoload insert-files
zle -N insert-files
bindkey '^xf' insert-files
bindkey -M viins '^xf' insert-files
bindkey -M vicmd '^xf' insert-files

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

## less
# default options
# also used for man
LESS+='--status-column ' # mark matched lines on the left side
LESS+='--HILITE-UNREAD ' # mark next unread line (not working with --status-column?)
LESS+='--RAW-CONTROL-CHARS ' # pass ansi colors
LESS+='--chop-long-lines ' # don't wrap long lines
LESS+='--no-init ' # probably don't clear the screen after exit
LESS+='--clear-screen ' # complete redraw when scrolling
LESS+='--jump-target=.3 ' # the target (for example when searching) is put at 1/3 from the top
export LESS

## other
#setopt extended_glob # problematic because ^ has to be escaped
setopt rm_star_silent # no confirmation anymore for "rm *"-like
setopt always_to_end # move to end of word after completion
setopt complete_in_word
setopt long_list_jobs
setopt noautocd # dont assume an implicit cd prefix for folder names
setopt no_list_beep # dont beep on incomplete/ambiguous completion
export SUDO_EDITOR=vim # for sudo -e or sudoedit
export MANOPT='--no-justification --no-hyphenation'
export PYTHONDONTWRITEBYTECODE=True # no .pyc files for python
stty -ixon # disables flow control, for example ctrl-s (useful in vim)

# --time-style for ls
# line 1 is non-recent, older than 6 months
# line 2 is recent, using italic for recent
export TIME_STYLE=+'[0m%F %R[0m
[3m%F %R[0m'

## solarized colors for ls
eval `dircolors ~/plugins/dircolors-solarized/dircolors.ansi-dark`

## easier output for when using 'set -x'
# todo if there was an "after ps4" we could use another color and undo it
# we show "location depth> context state" with inverted coloring for easy spotting
export PS4='%S%x:%I %e> %N:%i %_%s '
