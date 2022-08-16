
# see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
# for colors:
#   http://ethanschoonover.com/solarized
#   http://www.zovirl.com/2011/07/22/solarized_cheat_sheet/


# NOTE small impact on speed, even when not in a git folder
function _git_status_for_prompt {
    # could use 'timeout --kill-after=0.01s 0.01s cmd' to stop git info when it takes too long on a slow filesystem
    if [[ $(pwd -P) == /efs/* ]]; then
        # NOTE above takes any pattern, so something|otherthing|morestuff works instead of a list
        echo '%F{3}%f'
        return
    fi
    # NOTE plain 'git status' with no arguments can be slow because it checks all submodules
    # NOTE parsing like below is actually 2x faster than zsh's vcs_info
    # NOTE --porcelain=v1 would be preferred, but then --show-stash is ignored
    # NOTE some utf8 icons only worked when in tmux, double-check when using new ones
    local args=(--branch --ignore-submodules=all --untracked-files=normal --ahead-behind --show-stash)
    (git -c advice.statusHints=false status $args |& awk -v ORS='' '
        BEGIN { has=1; flags=0; print "%F{3}" }
        /^fatal: not a git repository/ { has=0 }
        /^On branch / { print " " $3 " " }
        /^HEAD detached at / { print " " $4 " " }
        /^Your branch is up to date with / { }
        /^Your branch is ahead of / { print ""; flags++ }
        /^Your branch is behind / { print ""; flags++ }
        /^Your branch and .+ have diverged/ { print ""; flags++ }
        /^nothing to commit, working tree clean/ { }
        /^Unmerged paths:/ { if (flags>0) {print ""; flags++} }
        /^Changes to be committed:/ { print "ﭜ"; flags++ }
        /^Changes not staged for commit:/ { print "ﱴ"; flags++ }
        /^Untracked files:/ { print ""; flags++ }
        /^Your stash currently has / { print ""; flags++ }
        END {
            if (has==0) print ""
            if (has==1 && flags==0) print ""
            print "%f"
        }
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


function {
    # NOTE generally anything that needs subshells slows down the prompt
    # get full timings using > time zsh -ic 'time ( print -P $PS1 )'
    local n=$'\n'
    local alerts='%(?,,%F{1}%Sexit code = %?'$n'%s%f)'
    local headers=(
        '%K{0}%F{4}%B'  # colors and bold
        '%~%b%f'  # current folder
        '$(_git_status_for_prompt)'
        '%F{10}%*%f'  # time
    )
    if [[ ! -v TMUX ]]; then
        headers+=('%F{10}%m%f')  # host
    fi
    headers+=(
        '%F{4}${VIRTUAL_ENV:+}%f'  # virtual env
        '%(1j,%F{1} %j&%f,)'  # background jobs
        # '$(_prompt_sudo)'
        '%E%k'  # fill to end of line
    )
    local edit='%F{15}${${${KEYMAP:-main}/vicmd/N}/(main|viins)/I}>%f '
    # NOTE it's nice do do it with the join operator, but it's not always correct
    # eg VENV can be empty, and then should not have a space on both sides?
    # also host could be done with ${:...} instead of an if?
    # actually I'm not sure if join-expansion maybe can ignore empty entries
    # to test that need to move the color escape _inside_ the ${:} so it's actually empty
    # ah no, it's never empty, that's before the expansion :)
    # so back to manual spaces, but a join with nothing?
    PS1=$n$alerts$n${(j/ /)headers}$n$edit
}


# see 'man zshzle' for reporting the current vim mode
function zle-keymap-select() {
    zle reset-prompt
    zle -R
}
zle -N zle-keymap-select


## easier output for when using 'set -x'
# we show "[context/trace]" with faint color and on its own line
# and then indented the expanded line
# this way it should be easy to skip/ignore and understand what is the actual output
# but we cannot color the actual expansion :/ because there is no PS4_after or similar
# '[%x:%I %e]' might sometimes be more useful? not sure when it's different from the more default below
PS4='%K{0}%F{10}[%N:%i %_]%f%k
  > '


export PS1 PS4
