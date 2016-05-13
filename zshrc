source ~/antigen/antigen.zsh

# todo where do the oh-my-zsh settings go?
DISABLE_AUTO_UPDATE="true" # todo it will happen with antigen update?
antigen use oh-my-zsh
antigen bundle command-not-found
antigen bundle per-directory-history
# might be interesting: common-aliases compleat

antigen bundle zsh-users/zaw
antigen bundle zsh-users/zsh-syntax-highlighting # note: might have to be the last to import

# some themes: random, agnoster, blinks, robbyrussell, amuse, avit, blinks, funky, ys, pure, tjkirch
antigen theme agnoster

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
# todo as bundle for antigen?
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

# todo: bind (should already be bound)
bindkey '^G' per-directory-history-toggle-history

# global history by default
_per-directory-history-set-global-history

# some xpman shortcuts
xp_mag () { # mount and go to xp
	if [ ! -d $1 ]; then
		mkdir -p $1
	fi
	f=$(realpath $1)
	echo 'xp' $f
	xpman mount_xp $f
	cd $1
}
xp_lau () { # leave and unmount
	f=$(realpath $1)
	cd ~
	echo 'xp' $f
	xpman umount_xp $f
}
xp_las () { # leave and start on demand
	f=$(realpath $1)
	echo 'xp' $f
	cd ~
	xpman umount_xp $f
	echo 'starting' "$2"
	xpman start_xp_on_demand $f "$2"
}
xp_update () { # update to what's on $dev right now, fails if there are uncommited things
	if [[ -d nn ]]; then
		if [[ -z $(cd nn; git status -s) ]]; then
			rm -rf nn
			cp -r $dev/nn .
		else
			echo 'nn has uncommited changes'
			return
		fi
	else
		echo 'no nn folder'
		return
	fi
	if [[ -d caffe ]]; then
		if [[ -z $(cd caffe; git status -s) ]]; then
			rm -rf caffe
			cp -r $dev/caffe .
		else
			echo 'caffe has uncommited changes'
			return
		fi
	else
		echo 'no caffe folder'
		return
	fi
}
xp_replace () {
	rm -rf nn
	cp -r $dev/nn .
	rm -rf caffe
	cp -r $dev/caffe .
}
xp_link () {
	rm -rf nn
	ln -sf $dev/nn nn
	rm -rf caffe
	ln -sf $dev/caffe caffe
}
xp_cxp () { # change xp (unmount current, mount new)
	a=$(realpath .)
	cd ~
	xpman umount_xp $a
	xpman mount_xp $1
	cd $1
}

# copy latest snapshot to dev with proper naming for further training (stages)
xp_snap () { s=$(ls snapshots/*.caffemodel | tail -n 1); x=$(basename $(realpath .)); x=$x[12,-1]; y=$(basename $s); cp $s $dev/${x}_$y }

# copy with progress, use rsync, not sure about $1/ or $1 without / and rsyncs semantics
rsync_cp () {
	rsync -ah -L -r --info=progress2 $1 $2
}

export PYTHONDONTWRITEBYTECODE=True # no .pyc files for python

stty -ixon # disables flow control, for example ctrl-s
