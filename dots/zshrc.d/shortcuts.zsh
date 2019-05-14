
# ls
alias ls='ls --color=auto'
alias lr='ls -hltrcF'
alias la='ls -lhFva'
alias ll='ls -lhFv'
alias lll='ls -lhFv --color=yes | less -R'
alias lsdirs='ls -v -d */'
alias lldirs='ls -vldh */'
# lrt () { ls -hltrcF --color=always "$@" | tail }

## navigation
# todo zsh supports .. and ... without aliases?
#alias ..='cd ..'
#alias ...='cd ../..'
# go back to a parent folder (default first parent)
.. () {
    1=${1:-$(basename $(dirname $(pwd)))}
    while [[ $(basename $(pwd)) != $1 ]]; do
        cd ..
    done
}
_complete_.. () {
    reply=$(pwd)
    reply=(${(s|/|)reply})
}
compctl -K _complete_.. ..
cdl () { cd $1 && echo && echo 'lr of ' $(pwd) && echo && lr }
compctl -/ cdl # only complete directories for cdl
rcd () { cd $(pwd) } # reacquire inode when current path was recreated
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
alias feh='feh --auto-zoom --scale-down --draw-filename --draw-tinted'
alias ffeh='feh --fullscreen --draw-filename --draw-tinted'

# rsync copy with progress
# todo not sure about $1/ or $1 semantics
rsync_cp () {
    rsync -ah -L -r --info=progress2 $1 $2
}