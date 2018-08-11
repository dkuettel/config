source ~/antigen/antigen.zsh
source ~/config/antigenrc
# check http://antigen.sharats.me/
# antigen update for plugins
# antigen selfupdate for antigen
# antigen list is also interesting
# antigen init could speed up, not sure (but is less automatic when changes happens, see doc)
# antigen init ~/config/antigenrc

# todo
# antigen selfupdate # update antigen
# antigen update # update bundles
# antigen cleanup # remove what's not loaded right now

# color support for ls with the solarized theme
# todo as bundle for antigen? have to make my own clone for that with a *.zsh to use for bundle
eval `dircolors ~/plugins/dircolors-solarized/dircolors.ansi-light`

# extended globbing, any conflicts?
setopt extendedglob

# for feh to work well with tiling window manager
alias feh='feh --auto-zoom --scale-down --draw-filename --draw-tinted'
alias ffeh='feh --fullscreen --draw-filename --draw-tinted'

# for mosh, but in general, i'm not comfortable with all the LC settings
export LC_ALL=en_US.UTF-8

# todo: bind (should already be bound)
bindkey '^G' per-directory-history-toggle-history

# global history by default
_per-directory-history-set-global-history

# some xpman shortcuts

xp-check () {
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

xp-mag () { # mount and go to xp
	if [ ! -d $1 ]; then
		mkdir -p $1
	fi
	f=$(realpath $1)
	echo 'mount and go ' $f
	xpman mount_xp --wait $f
	cd $1
}

xp-lau () { # leave and unmount cwd
	before=$(pwd)
	until findmnt . > /dev/null; do cd ..; done
	f=$(realpath $(pwd))
	cd $dev
	echo 'leave and unmount' $f
	xpman umount_xp $f || cd $before
}

xp-rem () { # remount for flushing to ebs
	f=$(realpath $(pwd))
	xp-lau
	xp-mag $f
}

xp-lad () { # leave and delete
	f=$(realpath $(pwd))
	cd $dev
	echo 'leave and delete' $f
	xpman umount_xp $f
	xpman delete_xp $f
}

xp-las-new () { # leave and start on demand cwd
	if xp-check; then
		f=$(realpath $(pwd)) &&
		echo 'leave' $f 'and start' "$1" &&
		cd $dev &&
		xpman umount_xp $f &&
		xpman start_xp_on_demand $f "$1" --gpu_type=1new
	else
		return 1
	fi
}

xp-las-old () { # leave and start on demand cwd on old gpu instance
	if xp-check; then
		f=$(realpath $(pwd)) &&
		echo 'leave' $f 'and start' "$1" &&
		cd $dev &&
		xpman umount_xp $f &&
		xpman start_xp_on_demand $f "$1" --gpu_type=1old
	else
		return 1
	fi
}

xp-tam () { # terminate and mag (mount and go)
	f=$(realpath $1)
	xpman terminate_xp --wait $f
	xp-mag $f
}

xp-replace () {
	if [ $(realpath .) = $(realpath $dev) ]; then
		echo 'cannot replace when inside dev'
		return 1
	else
		echo 'replace code with dev code'
		(rm -rf nn && cp -r $dev/nn .) &
		(rm -rf caffe && cp -r $dev/caffe .) &
		echo 'wait'
		wait
	fi
}

xp-link () {
	# todo this would better be a script with -eux, only few need to be functions
	if [ $(realpath .) = $(realpath $dev) ]; then
		echo 'cannot link when inside dev'
		return 1
	else
		echo 'link to code from dev'
		if [ -d nn.removing ]; then
			echo 'nn.removing exists already'
			return 1
		fi
		mv nn nn.removing
		rm -rf nn.removing &
		ln -sf $dev/nn nn
		if [ -d caffe.removing ]; then
			echo 'caffe.removing exists already'
			return 1
		fi
		mv caffe caffe.removing
		rm -rf caffe.removing &
		ln -sf $dev/caffe caffe
	fi
}

xp-cxp () { # change xp (unmount current, mount new)
	echo 'change to xp' $1
	a=$(realpath .)
	cd $dev
	xpman umount_xp $a
	xpman mount_xp $1
	cd $1
}

xp-fork () { # fork dev
	xpman fork_xp_dated $dev $runs $1 $2
}

xp-grid () { # grid fork dev
	xpman fork_xp_dated_grid $dev $runs "$@"
}

xp-find () {
	xpman list_xps --raw --regexp $1
}

xp-ssh () {
	xpman issh $1 --wait
}

# copy with progress, use rsync, not sure about $1/ or $1 without / and rsyncs semantics
rsync_cp () {
	rsync -ah -L -r --info=progress2 $1 $2
}

xp-watch () {
	while true
	do
		xpman list_xps --reverse | less -c
	done
}

alias xpc='python -m nn.xp_config'

export PYTHONDONTWRITEBYTECODE=True # no .pyc files for python

stty -ixon # disables flow control, for example ctrl-s

rcd () {
	# sometimes when current folder is invalid because it has been recreated
	# rcd goes again to the same name but new inode
	cd $(pwd)
}


xp-py () {
	ipython --InteractiveShellApp.exec_files='["/home/kuettel/config/xp-py.py"]'
}

xp-feh () {
	echo $(realpath .)
	echo
	cat info.txt
	echo
	xpc
	echo
	#./sxp scores
	#ffeh logs/plots/losses.png >/dev/null 2>&1
	#ffeh logs/plots/lr.png >/dev/null 2>&1
	#ffeh evals/last/cad/conf_ops.png >/dev/null 2>&1
	[[ -d logs/d ]] && ffeh logs/d/plots/losses-log.png logs/d/plots/accuracies.png logs/g/plots/losses-log.png logs/g/plots/accuracies.png
	[[ -d logs/plots ]] && ffeh logs/plots/losses-log.png logs/plots/accuracies.png
}

setopt rm_star_silent # no confirmation anymore for "rm *"-like

alias man='man --no-justification'

exo () { # echo and execute a command (for selective verbosity, instead of zsh -x or -v)
	echo "> $@"
	$@
}

# can use vim for man pager, also support c-] for follwing "links"
#export MANPAGER="env MAN_PN=1 vim -M +MANPAGER -"

mtar () {
	$dev/src/nn/mtar/$1 "$@[2,-1]"
}

export SUDO_EDITOR=vim # for sudo -e
