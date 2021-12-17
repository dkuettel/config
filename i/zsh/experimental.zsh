f=~/toys/ecopy/widget.zsh; [[ -e $f ]] && source $f

# pipenv sanity as far as it is possible
export PIPENV_COLORBLIND=yes
export PIPENV_HIDE_EMOJIS=yes
# todo: there is also the --bare option, but no env variable for it
# default python version for a new pipenv environment
export PIPENV_DEFAULT_PYTHON_VERSION=3.8
export PIPENV_VENV_IN_PROJECT=1

# default ncal settings
alias ncal='ncal -bM3'

# nvim
alias v=nvim

# correct set of envs? shells usually try VISUAL first and then EDITOR
export SUDO_EDITOR=nvim
export VISUAL=nvim
export EDITOR=nvim

# jql colors
JQ_COLORS='2;30:2;30:2;30:2;30:0;32:1;39:1;39'

# one-shell-history
f=~/config/i/osh/osh/zsh/setup.zsh; [[ -e $f ]] && source $f

# gpu usage per process
alias watch-gpu='watch nvidia-smi pmon -c 1'

# multipass, any name clashes like this?
alias mp=multipass

# make search case-insensitive if no capital letters in query
alias less='less -i'

alias k=kubectl

# try man in nvim
# also nvim with :Man quite cool when editing a script, copy options right out of it
export MANPAGER='nvim +Man!'
