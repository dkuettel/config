f=~/toys/ecopy/widget.zsh; [[ -e $f ]] && source $f

# default ncal settings
alias ncal='ncal -bM3'

# nvim
alias v=nvim
# nvim with alternative configuration
# alias V='XDG_CONFIG_HOME=~/revim/config XDG_CONFIG_DIRS= XDG_DATA_HOME=~/revim/data XDG_DATA_DIRS= nvim'

# jql colors
JQ_COLORS='2;30:2;30:2;30:2;30:0;32:1;39:1;39'

# one-shell-history
# NOTE impacts startup speed
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
# NOTE used to have https://github.com/zlsun/solarized-man for colors when not in vim

# generically run python with some debug settings
alias py-i='PYTHONBREAKPOINT=ipdb.set_trace'
alias py-e='PYTHONBREAKPOINT=IPython.embed'
alias py-w='PYTHONBREAKPOINT=web_pdb.set_trace'
alias py-0='PYTHONBREAKPOINT=0'
# function debug {
#     (
#         case $1 in
#             (interactive|i) export PYTHONBREAKPOINT='ipdb.set_trace';;
#             (embed|e) export PYTHONBREAKPOINT='IPython.embed';;
#             (web|w) export PYTHONBREAKPOINT='web_pdb.set_trace';;
#             (0) export PYTHONBREAKPOINT='0';;
#             (*) echo "$1 is unknown" >&2; exit 1;;
#         esac
#         echo "  > using $PYTHONBREAKPOINT\n"
#         $@[2,-1]
#     )
# }

function take {
    # mkdir and go there
    mkdir -p $1
    cd $1
}

# generally makes sense in scripts, do we want it in interactive?
# NOTE it doesnt propagate into scripts
set -u -o pipefail
