
# adapted and shorter only for debian from
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/command-not-found/command-not-found.plugin.zsh

function command_not_found_handler {
    /usr/lib/command-not-found -- "$1"
}
