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

xp_mag () { # mount and go to xp
	if [ ! -d $1 ]; then
		mkdir -p $1
	fi
	f=$(realpath $1)
	echo 'mount and go ' $f
	xpman mount_xp $f
	cd $1
}

xp_lau () { # leave and unmount cwd
	f=$(realpath $(pwd))
	cd $dev
	echo 'leave and unmount' $f
	xpman umount_xp $f
}

xp_las () { # leave and start on demand cwd
	f=$(realpath $(pwd))
	echo 'leave' $f 'and start' "$1"
	cd $dev
	xpman umount_xp $f
	xpman start_xp_on_demand $f "$1"
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

# copy latest snapshot to dev with proper naming for further training (stages)
xp_snap () { s=$(ls snapshots/*.caffemodel | tail -n 1); x=$(basename $(realpath .)); x=$x[12,-1]; y=$(basename $s); cp $s $dev/${x}_$y }

xp_ssh () {
	xpman ssh_to_xp $1 --wait --ssh_opts='-t' --cmd='~/bin/tmux at'
}

# copy with progress, use rsync, not sure about $1/ or $1 without / and rsyncs semantics
rsync_cp () {
	rsync -ah -L -r --info=progress2 $1 $2
}

xp_revals () {
	echo "cd $1; for i in disney_test_closeup disney_challenge disney_realistic disney_white hotwheels_test_closeup hotwheels_test hotwheels_realistic hotwheels_white; do echo \$i; cat evals/\$i/last/confusion.txt | grep 'class average'; echo; done" | xpman ssh_cmd $1
}

xp_levals () {
	for i in disney_test_closeup disney_challenge disney_realistic disney_white hotwheels_test_closeup hotwheels_test hotwheels_realistic hotwheels_white
	do
		echo $i
		for k in evals/$i/*
		do
			echo -n $(basename $k) " "
			cat $k/confusion.txt | grep 'class average'
		done
		echo
	done
	basename $(realpath evals/disney_challenge/last)
}

xp_watch () {
	while true
	do
		xpman list_xps --reverse | less -c
	done
}

xp_djf () {
	for i in disney_test_closeup disney_challenge disney_realistic disney_white hotwheels_test_closeup hotwheels_test hotwheels_realistic hotwheels_white
	do
		echo $i
		cat evals/$i/last/h1confusion.txt | grep class
		cat evals/$i/last/q1confusion.txt | grep class
		cat evals/$i/last/s1confusion.txt | grep class
		echo
	done
}

export PYTHONDONTWRITEBYTECODE=True # no .pyc files for python

stty -ixon # disables flow control, for example ctrl-s
