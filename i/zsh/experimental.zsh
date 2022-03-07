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
# nvim with alternative configuration
# removing runtime paths very aggressively for now
alias V='XDG_CONFIG_HOME=~/revim/config XDG_CONFIG_DIRS= XDG_DATA_HOME=~/revim/data XDG_DATA_DIRS= nvim'

# jql colors
JQ_COLORS='2;30:2;30:2;30:2;30:0;32:1;39:1;39'

# one-shell-history
if [[ -v OSH_TESTING ]]; then
    f=$OSH_TESTING/shells/zsh; [[ -e $f ]] && source $f
    path=($OSH_TESTING/bin $path)
else
    f=~/config/i/osh/osh/shells/zsh; [[ -e $f ]] && source $f
fi

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

# generically run python with some debug settings
function debug {
    (
        case $1 in
            (interactive|i) export PYTHONBREAKPOINT='ipdb.set_trace';;
            (embed|e) export PYTHONBREAKPOINT='IPython.embed';;
            (web|w) export PYTHONBREAKPOINT='web_pdb.set_trace';;
            (0) export PYTHONBREAKPOINT='0';;
            (*) echo "$1 is unknown" >&2; exit 1;;
        esac
        echo "  > using $PYTHONBREAKPOINT\n"
        $@[2,-1]
    )
}
