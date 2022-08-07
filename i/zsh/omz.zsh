# started from plugins/omz/templates/zshrc.zsh-template
# adapted with https://github.com/ohmyzsh/ohmyzsh/wiki/Settings

export ZSH=~/.zshrc.d/plugins/omz

# ZSH_THEME="robbyrussell"

zstyle ':omz:update' mode disabled

plugins=(command-not-found compleat)

source $ZSH/oh-my-zsh.sh
