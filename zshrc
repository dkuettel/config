source ~/antigen/antigen.zsh
antigen init ~/.antigenrc # todo does it really make it faster?
# This setup further improves cache performance (~0.02s). One caveat: antigen-init command doesn't look into bundle configuration changes, thus you'll need to use antigen-reset to reload plugins.
# see https://github.com/zsh-users/antigen/wiki/Cookbook#init-command

# history
# todo doesn't seem to update "live" yet ?
export HISTSIZE=1000000000
export SAVEHIST=1000000000
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_save_no_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history

# so that bin/activate does not mess with PS1, we do it ourselves
export VIRTUAL_ENV_DISABLE_PROMPT=true

# adapted theme: amuse + tjkirch
PROMPT='%(?,,
%{$fg[red]%}FAIL: $?%{$reset_color%}
)
%{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info) ⌚ %{$fg_bold[red]%}%*%{$reset_color%} ${VIRTUAL_ENV+(env)}
${${KEYMAP/vicmd/N}/(main|viins)/I}> '
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
function zle-line-init zle-keymap-select {
	zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
# todo I don't understand why I can do all in PROMPT (using KEYMAP), but KEYMAP is only set when it's triggered with a reset-prompt?

# todo
# antigen selfupdate # update antigen
# antigen update # update bundles
# antigen cleanup # remove what's not loaded right now

# note: ~ does not expand, but $HOME does
# todo includes both cuda 7 and 8 for now
export PATH="$HOME/config/bin:$HOME/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/cuda-7.0/bin:/usr/local/cuda-8.0/bin"

# todo: try zaw for history search
# todo currently not using anymore
# bindkey '^R' zaw-history

alias ls='ls --color=auto'
alias lr='ls -hltrcF'
alias l='ls -lhFva'
alias ll='ls -lhFv'
alias lll='ls -lhFv --color=yes | less -R'
alias lsdirs='ls -v -d */'
alias lldirs='ls -vldh */'
alias d+='pushd .'
alias d-='popd'
#alias ..='cd ..'
#alias ...='cd ../..'
#alias lrt='ls -hltrcF --color=always | tail' # use script in ~/bin instead
alias watch='watch --color -n 1 ' # an alias ending with a space allows for more alias expansion after that, so now watch ll should work (for example)

cdl () {
	cd $1 &&
	lr
}

# color support for ls with the solarized theme
# todo as bundle for antigen? have to make my own clone for that with a *.zsh to use for bundle
eval `dircolors ~/plugins/dircolors-solarized/dircolors.ansi-light`

# option -J is also interesting
# but I'd rather highlight the whole line with a match after searching and key n
export LESS="-j.3 -WRSXc"

# try it for now
#source ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh

# try vim mode for zle
bindkey -v
export KEYTIMEMOUT=1 # quicker reaction to mode change (might interfere with other things) (1=0.1seconds)
# Use vim cli mode
bindkey '^P' up-history
bindkey '^N' down-history
# backspace and ^h working even after
# returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
# ctrl-w removed word backwards
bindkey '^w' backward-kill-word
# ctrl-r starts searching history backward
#bindkey '^r' history-incremental-search-backward
#bindkey '^r' znt-history-widget
bindkey '^r' history-search-multi-word # todo not sure why I have to do it here, the plugin does it already, but it doesnt work
# edit command line in editor
bindkey '^x^e' edit-command-line

# extended globbing, any conflicts?
setopt extendedglob

# ssh auth in tmux
#alias sshca_set='. sshca_set.sh'
#alias tmux='sshca_bind; SSH_AUTH_SOCK=~/.ssh/ssh-auth-sock.tmux ~/tmux/tmux'

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

export PATH="$PATH:/data/xps/metric/dev/nn/bin"

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

