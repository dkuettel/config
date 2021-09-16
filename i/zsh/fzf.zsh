
# see i/fzf

# path already set in paths.zsh

# auto completion
source /usr/share/doc/fzf/examples/completion.zsh

# fzf default key bindings
# ctrl-t for adding files to current command
# ctrl-r for searching history, but we change it later for one-shell-history
# alt-c to cd to directory
# and some/path/**<tab> finds file starting there (that's actually set in completion above)
# kill <tab> and maybe other commands
source /usr/share/doc/fzf/examples/key-bindings.zsh

# defaults
#export FZF_CTRL_T_COMMAND=?
export FZF_CTRL_T_OPTS='--layout=reverse'
export FZF_CTRL_R_OPTS='--layout=reverse'
export FZF_ALT_C_OPTS='--layout=reverse --preview=ls\ {}'


# TODO notes
# completion is for both fzf options and **? or just for **
# the ** feels a bit shaky, maybe remove it and just map it to shortcuts?
# like ctrl-f prefix always, then b for branch, f for files, g for git relevant files? and so on
# ctrl-f is already the ecopy, map it to ctrl-f t or e for tmux or easy? mapping to whats visible?
# note, eg, ctrl-f b not ctrl-f ctrl-b


function __fzf_branch () {
    function branches () {
        # local branches
        git branch --format '%(refname:short)'
        # remote branches that look like local branches
        git branch --remotes --format '%(refname:lstrip=3)'
        # remote branches
        git branch --remotes --format '%(refname:short)'
    }
    branch=$(branches | sort | uniq | fzf)
    LBUFFER="${LBUFFER}$branch"
    zle reset-prompt
}
zle -N __fzf_branch
bindkey '^fb' __fzf_branch


function __fzf_git () {
    # TODO this also lists already added files, maybe thats okay, lets see how it goes
    files=$(git status --short | fzf --nth=2.. --multi | awk -v ORS=' ' 'match($0, /.. (.*)/, m) { print m[1] }')
    # TODO not sure if we need some ${=files} or ${(f)files} for proper escaping?
    LBUFFER="${LBUFFER}$files"
    zle reset-prompt
}
zle -N __fzf_git
bindkey '^fg' __fzf_git
