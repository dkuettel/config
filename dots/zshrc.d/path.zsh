
# note: ~ does not expand, but $HOME does
# careful if you add or append depending on use case
# todo anyway to prevent duplication?

export PATH
PATH=$HOME/config/bin:$PATH
PATH=$HOME/.local/bin:$PATH # seems not to be there by default, for example pip install puts executables there
#export PATH=$HOME/config/bin:$PATH
#export PATH=$PATH:/usr/local/cuda/bin
#export PATH=$PATH:$HOME/config/bin:$HOME/bin
#export PATH=$PATH:$HOME/dev/main/nn/bin
