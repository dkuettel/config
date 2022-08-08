
# see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
# for colors:
#   http://ethanschoonover.com/solarized
#   http://www.zovirl.com/2011/07/22/solarized_cheat_sheet/


# NOTE small impact on speed, even when not in a git folder
function _git_status_for_prompt {
    # could use 'timeout --kill-after=0.01s 0.01s cmd' to stop git info when it takes too long on a slow filesystem
    if [[ $(pwd -P) == /efs/* ]]; then
        # NOTE above takes any pattern, so something|otherthing|morestuff works instead of a list
        return
    fi
    # NOTE plain 'git status' with no arguments can be slow because it checks all submodules
    # NOTE parsing like below is actually 2x faster than zsh's vcs_info
    # NOTE --porcelain=v1 would be preferred, but then --show-stash is ignored
    local args=(--branch --ignore-submodules=all --untracked-files=normal --ahead-behind --show-stash)
    (git -c advice.statusHints=false status $args |& awk -v ORS='' '
        BEGIN { has=1; flags=0; print "%F{3}" }
        /^fatal: not a git repository/ { has=0 }
        /^On branch / { print " " $3 " " }
        /^HEAD detached at / { print " " $4 " " }
        /^Your branch is up to date with / { }
        /^Your branch is ahead of / { print ""; flags++ }
        /^Your branch is behind / { print ""; flags++ }
        /^Your branch and .+ have diverged/ { print ""; flags++ }
        /^nothing to commit, working tree clean/ { }
        /^Unmerged paths:/ { if (flags>0) {print ""; flags++} }
        /^Changes to be committed:/ { print "ﭜ"; flags++ }
        /^Changes not staged for commit:/ { print "ﱴ"; flags++ }
        /^Untracked files:/ { print "ﬤ"; flags++ }
        /^Your stash currently has / { print "" }
        END { if (has==1 && flags==0) print ""; print "%F{3}%f" }
    ') || true
}


# NOTE small impact on speed
function _prompt_sudo {
    # indicate if sudo currently has cached authentication
    # NOTE this resets the timeout everytime, maybe not useful, or use 'sudo -k' manually? let's see how it goes.
    sudo -nv &>/dev/null || exit
    echo ' %F{1}sudo%f'
}


# enable expansions for prompts like PS1
setopt prompt_subst  # apply typical expansions like: $, ${, $(, ((, ...
setopt prompt_percent  # apply expansions for "%"


# NOTE generally anything that needs subshells slows down the prompt
# TODO the PS1 string is hard to read, plus it doesnt handle spaces between flags quite right, can we split it up?

# new line
PS1=$'\n'
# exit code alert
PS1+='%(?,,%F{1}%Sexit code = %?%s%f'$'\n'')'
# header line elements
PS1+=$'\n'
PS1+='%K{0}%F{4}%B'  # colors and bold
PS1+=' %~%b%f'  # current folder
PS1+='$(_git_status_for_prompt)'
PS1+=' %F{10}%*%f'  # time
PS1+=' %F{5}(%m)%f'  # host
PS1+='%F{9}${VIRTUAL_ENV:+%B =venv=%b}%f'  # virtual env
PS1+='%(1j,%F{1} %j&%f,)'  # background jobs
# PS1+='$(_prompt_sudo)'
PS1+=$'%E%k\n'  # fill to end of line
# input line
PS1+='%F{15}${${${KEYMAP:-main}/vicmd/N}/(main|viins)/I}>%f '
export PS1


# see 'man zshzle' for reporting the current vim mode
function zle-keymap-select() {
    zle reset-prompt
    zle -R
}
zle -N zle-keymap-select
