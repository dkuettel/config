
# ls
alias ls='ls -v --color=auto'
alias lr='ls -cFGghrt --color=always'
alias la='ls -aFhlv --color=always'
alias ll='ls -Fhlv --color=always'
function lll { ls -Fhlv --color=always $@ | less -R }
alias lsd='ls -v -d */'
alias lld='ls -hlv -d */'
# function lrt { ls -hltrcF --color=always $@ | tail }

# todo zsh supports .. and ... without aliases?
#alias ..='cd ..'
#alias ...='cd ../..'
# go back to a named parent folder, or one up if no name given
function .. {
    if [[ -v 1 ]]; then
        local x
        x=$(pwd)
        x=${x:h}
        until [[ ${x:t} == $1 || $x == / ]]; do
            x=${x:h}
        done
        if [[ $x == / ]]; then
            echo 'cannot find a parent folder named' $1
        else
            cd $x
        fi
    else
        cd ..
    fi
}
function _complete_.. {
    reply=$(pwd)
    reply=(${(s|/|)reply})
}
compctl -K _complete_.. ..

function cdl { cd $1 && echo && echo 'lr of ' $(pwd) && echo && lr }
compctl -/ cdl # only complete directories for cdl

function rcd { cd $(pwd) } # reacquire inode when current path was recreated

#alias d+='pushd .'
#alias d-='popd'

# (a space at the end of an alias allows further aliases)
alias watch='watch --color -n 1'

# poor man's watch
# it uses stdout so colors are supported by default
pwatch () {
    while true; do
        clear
        date
        echo "> $1"
        echo
        eval $1
        sleep 2
    done
}
compctl -c pwatch # complete commands

# robust tail
# -F = follow and retry
# disable-inotify makes it never rely on any inode, but it means polling, so slower
#alias tailf='tail -F ---disable-inotify'
alias tailf='tail -F'

# feh
alias feh='feh --auto-zoom --scale-down --draw-filename --draw-tinted --font UbuntuMono-Bold/35 --fontpath ~/.fonts'
alias ffeh='feh --fullscreen --draw-filename --draw-tinted --font UbuntuMono-Bold/35 --fontpath ~/.fonts'

# "human sync" with progress, but slash/no-slash semantics are not very human
# TODO looks like newer coreutils (maybe on ubuntu 20.04) have a progress switch
alias hsync='rsync -ah -L -r --info=progress2'

# tensorboard
function tb {
    set -x
    tensorboard --bind_all --logdir=${1:-.}
}

# jq with less and colors
function jql {
    if [[ $# == 1 ]]; then
        ( echo 'assuming first argument .'; jq --color-output . $@ ) | less
    else
        jq --color-output $@ | less
    fi
}

# todo for now assuming globally installed, could also use a canonical pipenv?
# lets see if fast enough, tf might be heavy/slow to import everytime?
alias ipy="TF_CPP_MIN_LOG_LEVEL=2 ipython3 -c 'import numpy as np, tensorflow as tf, pandas as pd, math; from pathlib import Path' -i"

function treel { tree -C $@ | less }

# playing around with systemd aliases
alias sc='sudo systemctl'
alias sc-status='sudo systemctl status'
alias jc=journalctl
# show all log of current boot
alias jc-this-boot='journalctl --boot=0'
# show all log of last boot
alias jc-last-boot='journalctl --boot=-1'

# docker kill
alias dk='docker kill'

# show only the "relevant" entries
alias dfe='df -h -t ext4'

# vlc restart file (even if opened before, no continue)
alias vlc0='vlc --start-time 0'

# git
alias g=git
alias gl='git l'
alias gf='git f'
alias gp='git p'
alias gd='git d'
alias gm='git m'

# completion for tmux-bind-g
compctl -c tmux-bind-g
