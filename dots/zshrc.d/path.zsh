
typeset -U PATH path # array with no duplicates
# note: ~ does not expand here, but $HOME does
path=(
    $HOME/config/bin
    $HOME/bin
    $HOME/fzf/bin
    $HOME/.local/bin
    /snap/bin $path
)

#PATH=$HOME/.local/bin:$PATH # seems not to be there by default, for example pip install puts executables there
#export PATH=$HOME/config/bin:$PATH
#export PATH=$PATH:/usr/local/cuda/bin
#export PATH=$PATH:$HOME/config/bin:$HOME/bin
#export PATH=$PATH:$HOME/dev/main/nn/bin
