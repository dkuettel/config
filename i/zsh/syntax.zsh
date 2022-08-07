# NOTE this needs to be source last in zshrc for it to work
# https://github.com/zsh-users/zsh-syntax-highlighting

source ~/.zshrc.d/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/efs)
ZSH_HIGHLIGHT_MAXLENGTH=2000
