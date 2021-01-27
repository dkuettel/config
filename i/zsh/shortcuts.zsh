
# ls
alias ls='ls --color=auto'
alias lr='ls -htrcFgG --time-style=iso'
alias la='ls -lhFva'
alias ll='ls -lhFv'
function lll { ls -lhFv --color=yes $@ | less -R }
alias lsdirs='ls -v -d */'
alias lldirs='ls -vldh */'
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
alias watch='watch --color -n 1 '

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
# disable-inotify makes it never rely on any inode
alias tailf='tail -F ---disable-inotify'

# feh
alias feh='feh --auto-zoom --scale-down --draw-filename --draw-tinted --font UbuntuMono-Bold/35 --fontpath ~/.fonts'
alias ffeh='feh --fullscreen --draw-filename --draw-tinted --font UbuntuMono-Bold/35 --fontpath ~/.fonts'

# "human cp"
# rsync copy with progress
# todo not sure about $1/ or $1 semantics
hcp () {
    rsync -ah -L -r --info=progress2 $1 $2
}

# tensorboard
function tb { tensorboard --logdir=${1:-.} }

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
alias ipy="ipython3 -c 'import numpy as np, tensorflow as tf, math' -i"

function treel { tree -C $@ | less }

alias sc=systemctl
alias jc=journalctl

# make vlc use the custom config from git
alias vlc='vlc --config ~/config/i/vlc/vlcrc'

# docker kill
alias dk='docker kill'
