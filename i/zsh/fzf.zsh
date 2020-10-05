
# see https://github.com/junegunn/fzf

# path already set in paths.zsh

# auto completion (if interactive)
[[ $- == *i* ]] && source $HOME/fzf/shell/completion.zsh 2> /dev/null

# key bindings
# ctrl-t for adding files to current command
# ctrl-r for searching history
# alt-c to cd to directory
# and some/path/**<tab> finds file starting there
# kill <tab>
source $HOME/fzf/shell/key-bindings.zsh

# defaults
#export FZF_CTRL_T_COMMAND=?
export FZF_CTRL_T_OPTS='--layout=reverse'
export FZF_CTRL_R_OPTS='--layout=reverse'
export FZF_ALT_C_OPTS='--layout=reverse --preview=ls\ {}'
