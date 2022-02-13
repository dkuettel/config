
# see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
# for colors:
#   http://ethanschoonover.com/solarized
#   http://www.zovirl.com/2011/07/22/solarized_cheat_sheet/


function _git_status_for_prompt {
    # could use 'timeout --kill-after=0.01s 0.01s cmd' to stop git info when it takes too long on a slow filesystem
    if [[ $(realpath .) == /efs/* ]]; then
        # note: above takes any pattern, so something|otherhing|morestuff works instead of a list
        echo '(~slow~) '
        exit
    fi
    (git status --show-stash |& awk -v ORS='' '
        BEGIN { flags=1 }
        /^fatal: not a git repository/ { has_git=0 }
        /^On branch / { print " %F{3}(" $3; has_git=1 }
        /^HEAD detached at / { print " %F{3}(detached"; has_git=1 }
        /^Your branch is up to date with / { }
        /^Your branch is ahead of / { print " ↑ " }
        /^Your branch is behind / { print " ↓ " }
        /^Your branch and .+ have diverged/ { print " ↕ " }
        /^nothing to commit, working tree clean/ { print " ✓ " }
        /^Unmerged paths:/ { if (flags>0) {print " %F{10}conflicts"; flags--} }
        /^Changes to be committed:/ { if (flags>0) {print " %F{10}uncommited"; flags--} }
        /^Changes not staged for commit:/ { if (flags>0) {print " %F{10}unstaged"; flags--} }
        /^Untracked files:/ { if (flags>0) {print " %F{10}untracked"; flags--} }
        /^Your stash currently has / { print " %F{1}stash" }
        END { if (has_git) print "%F{3})%f" }
    ') || true
}


function _prompt_sudo {
    # indicate if sudo currently has cached authentication
    # NOTE this resets the timeout everytime, maybe not useful, or use 'sudo -k' manually? let's see how it goes.
    sudo -nv &>/dev/null || exit
    echo ' %F{1}sudo%f'
}


# enable expansions for prompts like PS1
setopt prompt_subst  # apply typical expansions like: $, ${, $(, ((, ...
setopt prompt_percent  # apply expansions for "%"


# TODO the PS1 string is hard to read, plus it doesnt handle spaces between flags quite right, can we split it up?

# new line
PS1=$'\n'
# exit code alert
PS1+='%(?,,%F{1}%Sexit code = %?%s%f'$'\n'')'
# header line elements
PS1+=$'\n'
PS1+='%K{0}%F{4}%B'  # colors and bold
PS1+=' %~%b%f'  # current folder
PS1+='$(_git_status_for_prompt)'  # git prompt
PS1+=' %F{10}%*%f'  # time
PS1+=' %F{5}(%m)%f'  # host
PS1+='%F{9}${VIRTUAL_ENV:+%B =venv=%b}%f'  # virtual env
PS1+='%(1j,%F{1} %j&%f,)'  # background jobs
PS1+='$(_prompt_sudo)'  # sudo indicator
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
