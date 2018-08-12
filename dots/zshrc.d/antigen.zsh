
source ~/antigen/antigen.zsh
# see http://antigen.sharats.me/
# some commands:
#   antigen update # update plugins
#   antigen selfupdate # update antigen
#   antigen list # list of installed plugins
#   antigen clenaup # garbage collect
#   antigen theme # to switch to another theme (interactive)

# todo it does something with completion I can't reproduce yet
#DISABLE_AUTO_UPDATE="true" # todo it will happen with antigen update? (for oh-my-zsh?)
antigen use oh-my-zsh

# oh-my-zsh plugins (can be used without 'use oh-my-zsh'
antigen bundle command-not-found
antigen bundle per-directory-history
antigen bundle compleat # todo could be interesting to make completion for our xpman and co?

# plugins from directly from git
antigen bundle psprint/history-search-multi-word # widget to search history
antigen bundle zlsun/solarized-man # dark solarized colors for man
antigen bundle zsh-users/zsh-syntax-highlighting # note: might have to be the last to import
#antigen bundle Valiev/almostontop # always clear before new command (output always on top)

antigen apply


# configure

# per-directory-history
_per-directory-history-set-global-history # global by default
bindkey -M vicmd ',g' per-directory-history-toggle-history
bindkey -M viins '^xg' per-directory-history-toggle-history
