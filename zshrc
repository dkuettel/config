source ~/antigen/antigen.zsh

# todo where do the oh-my-zsh settings go?
DISABLE_AUTO_UPDATE="true" # todo it will happen with antigen update?
antigen use oh-my-zsh
antigen bundle command-not-found
antigen bundle per-directory-history
# might be interesting: common-aliases compleat

# antigen bundle zsh-users/zaw # todo this one doesn't work anymore with the new antigen caching
antigen bundle psprint/zsh-navigation-tools # todo also history, works, maybe better
antigen bundle zsh-users/zsh-syntax-highlighting # note: might have to be the last to import

# some themes: random, agnoster, robbyrussell, amuse, avit, blinks, funky, ys, pure, tjkirch
#antigen theme amuse

# adapted theme: amuse + tjkirch
PROMPT='%(?, ,
%{$fg[red]%}FAIL: $?%{$reset_color%}
)
%{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info) ⌚ %{$fg_bold[red]%}%*%{$reset_color%}
$ '
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

antigen apply

# todo
# antigen selfupdate # update antigen
# antigen update # update bundles
# antigen cleanup # remove what's not loaded right now

# note: ~ does not expand, but $HOME does
export PATH="$HOME/anaconda/bin:$HOME/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/cuda-7.0/bin"

# todo: try zaw for history search
bindkey '^R' zaw-history

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
# todo as bundle for antigen? have to make my own clone for that with a *.zsh to use for bundle
eval `dircolors ~/plugins/dircolors-solarized/dircolors.ansi-light`

# option -J is also interesting
# but I'd rather highlight the whole line with a match after searching and key n
export LESS="-j.3 -WRSXc"

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

# todo: bind (should already be bound)
bindkey '^G' per-directory-history-toggle-history

# global history by default
_per-directory-history-set-global-history

# some xpman shortcuts

xp_check () {
	if [ -L nn ]; then
		echo 'nn is linked'
	fi
	if [ -L caffe ]; then
		echo 'caffe is linked'
	fi
	if [ -L nn -o -L caffe ]; then
		return 1
	else
		return 0
	fi
}

xp_mag () { # mount and go to xp
	if [ ! -d $1 ]; then
		mkdir -p $1
	fi
	f=$(realpath $1)
	echo 'mount and go ' $f
	xpman mount_xp --wait $f
	cd $1
}

xp_lau () { # leave and unmount cwd
	f=$(realpath $(pwd))
	cd $dev
	echo 'leave and unmount' $f
	xpman umount_xp $f
}

xp_rem () { # remount for flushing to ebs
	f=$(realpath $(pwd))
	xp_lau
	xp_mag $f
}

xp_lad () { # leave and delete
	f=$(realpath $(pwd))
	cd $dev
	echo 'leave and delete' $f
	xpman umount_xp $f
	xpman delete_xp $f
}

xp_las () { # leave and start on demand cwd
	if xp_check; then
		f=$(realpath $(pwd)) &&
		echo 'leave' $f 'and start' "$1" &&
		cd $dev &&
		xpman umount_xp $f &&
		xpman start_xp_on_demand $f "$1" &&
	else
		return 1
	fi
}

xp_replace () {
	echo 'replace code with dev code'
	rm -rf nn
	cp -r $dev/nn .
	rm -rf caffe
	cp -r $dev/caffe .
}
xp_link () {
	echo 'link to code from dev'
	rm -rf nn
	ln -sf $dev/nn nn
	rm -rf caffe
	ln -sf $dev/caffe caffe
}

xp_cxp () { # change xp (unmount current, mount new)
	echo 'change to xp' $1
	a=$(realpath .)
	cd $dev
	xpman umount_xp $a
	xpman mount_xp $1
	cd $1
}

xp_fork () { # fork dev
	xpman fork_xp_dated $dev $runs $1 $2
}

xp_grid () { # grid fork dev
	xpman fork_xp_dated_grid $dev $runs "$@"
}

xp_find () {
	xpman list_xps --raw --regexp $1
}

xp_ssh () {
	xpman ssh_to_xp $1 --wait --ssh_opts='-t' --cmd='~/bin/tmux at'
}

# copy with progress, use rsync, not sure about $1/ or $1 without / and rsyncs semantics
rsync_cp () {
	rsync -ah -L -r --info=progress2 $1 $2
}

xp_watch () {
	while true
	do
		xpman list_xps --reverse | less -c
	done
}

export PYTHONDONTWRITEBYTECODE=True # no .pyc files for python

stty -ixon # disables flow control, for example ctrl-s

export PATH="$PATH:/data/xps/metric/dev/nn/bin"

rcd () {
	# sometimes when current folder is invalid because it has been recreated
	# rcd goes again to the same name but new inode
	cd $(pwd)
}
