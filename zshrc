# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="random"

# themes I tried
#ZSH_THEME="agnoster"
#ZSH_THEME="blink"
#ZSH_THEME="robbyrussell"
#ZSH_THEME="amuse"
ZSH_THEME="avit"
#ZSH_THEME="blinks"
#ZSH_THEME="funky"
#ZSH_THEME="ys"

# themes others used
#ZSH_THEME="pure" # cristi
#ZSH_THEME="tjkirch" # roman

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
#

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(command-not-found per-directory-history vi-mode zaw zsh-syntax-highlighting) # note: syntax plugin must be the last to import
# vi-mode disabled, it breaks syntax highlighting
plugins=(command-not-found per-directory-history zaw zsh-syntax-highlighting) # note: syntax plugin must be the last to import
# might be interesting: common-aliases compleat

# User configuration

# note: ~ does not expand, but $HOME does
export PATH="$HOME/anaconda/bin:$HOME/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/cuda-7.0/bin"
# export MANPATH="/usr/local/man:$MANPATH"

#DISABLE_AUTO_UPDATE=true # todo how to manually do it?
source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ls='ls --color=auto'
alias lr='ls -hltrcF'
alias ll='ls -lhF'
alias lll='ls -lhF --color=yes | less -R'
alias lsdirs='ls -d */'
alias lldirs='ls -ldh */'
alias d+='pushd .'
alias d-='popd'
#alias ..='cd ..'
#alias ...='cd ../..'
#alias lrt='ls -hltrcF --color=always | tail' # use script in ~/bin instead
alias cdl='. cdl.sh'
alias watch='watch -c'

# color support for ls with the solarized theme
eval `dircolors ~/plugins/dircolors-solarized/dircolors.ansi-light`

# option -J is also interesting
# but I'd rather highlight the whole line with a match after searching and key n
export LESS="-j.3 -WRSX"

# try it for now
#source ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh

# try vim mode for zle
#bindkey -v
#export KEYTIMEMOUT=1 # quicker reaction to mode change (might interfere with other things)
# Use vim cli mode
#bindkey '^P' up-history
#bindkey '^N' down-history
# backspace and ^h working even after
# returning from command mode
#bindkey '^?' backward-delete-char
#bindkey '^h' backward-delete-char
# ctrl-w removed word backwards
#bindkey '^w' backward-kill-word
# ctrl-r starts searching history backward
#bindkey '^r' history-incremental-search-backward

# extended globbing, any conflicts?
setopt extendedglob

# ssh auth in tmux
#alias sshca_set='. sshca_set.sh'
#alias tmux='sshca_bind; SSH_AUTH_SOCK=~/.ssh/ssh-auth-sock.tmux ~/tmux/tmux'

# for feh to work well with tiling window manager
alias feh='feh --auto-zoom --scale-down'

# for mosh, but in general, i'm not comfortable with all the LC settings
export LC_ALL=en_US.UTF-8

# todo: try zaw for history search
bindkey '^R' zaw-history

# todo: bind (should already be bound)
bindkey '^G' per-directory-history-toggle-history

# global history by default
_per-directory-history-set-global-history

# some xpman shortcuts
xp_mag () { # mount and go to xp
	f=$(realpath $1)
	xpman mount_xp $f
	cd $1
}
xp_lau () { # leave and unmount
	cd ~
	f=$(realpath $1)
	xpman umount_xp $f
}
xp_las () { # leave and start on demand
	cd ~
	f=$(realpath $1)
	xpman umount_xp $f
	xpman start_xp_on_demand $f "$2"
}
