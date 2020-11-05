source ~/toys/ecopy/widget.zsh

# pipenv sanity as far as it is possible
export PIPENV_COLORBLIND=yes
export PIPENV_HIDE_EMOJIS=yes
# todo: there is also the --bare option, but no env variable for it
# default python version for a new pipenv environment
export PIPENV_DEFAULT_PYTHON_VERSION=3.8
export PIPENV_VENV_IN_PROJECT=1

# default ncal settings
alias ncal='ncal -bM'

# nvim
alias v=nvim

# correct set of envs?
export SUDO_EDITOR=nvim
export VISUAL=nvim
export EDITOR=nvim

# jql colors
JQ_COLORS='2;30:2;30:2;30:2;30:0;32:1;39:1;39'

# one-shell-history
source ~/toys/one-shell-history/zsh/setup.zsh

# gpu usage per process
alias watch-gpu='watch nvidia-smi pmon -c 1'
