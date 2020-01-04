
typeset -U PATH path # array with no duplicates
# note: ~ does not expand here, but $HOME does
path=(
    $HOME/config/bin
    $HOME/bin
    $HOME/fzf/bin
    $HOME/.local/bin  # pip install puts executables here
    /snap/bin
    $path
)
