
typeset -U PATH path  # array with no duplicates

# note: we reverse, append, and reverse
# together with unique this adds only what's not already there
typeset -U rev
rev=(${(Oa)path})

# note: ~ does not expand here, but $HOME does
rev+=(
    /snap/bin  # should be there from system settings?
    $HOME/.local/bin  # pip install puts executables here
    #$HOME/fzf/bin  # not needed anymore, installed with apt now
    $HOME/.cargo/bin  # for rust cargo stuff, eg, see i/alacritty/setup
    $HOME/bin
    $HOME/config/bin
)

path=(${(Oa)rev})
