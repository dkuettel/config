
source ~/antigen/antigen.zsh
# see http://antigen.sharats.me/
# some commands:
#   antigen update # update plugins
#   antigen selfupdate # update antigen
#   antigen list # list of installed plugins
#   antigen cleanup # garbage collect
#   antigen theme # to switch to another theme (interactive)

# todo it does something with completion I can't reproduce yet
#DISABLE_AUTO_UPDATE="true" # todo it will happen with antigen update? (for oh-my-zsh?)
antigen use oh-my-zsh

# oh-my-zsh plugins (can be used without 'use oh-my-zsh')
antigen bundle command-not-found
#antigen bundle per-directory-history
antigen bundle compleat # todo could be interesting to make completion for our xpman and co?

# search history, now using one-shell history instead
#antigen bundle psprint/history-search-multi-word

# dark solarized colors for man
antigen bundle zlsun/solarized-man

# always clear before new command (output always on top)
#antigen bundle Valiev/almostontop

# syntax highlighting
# as of 2021-08-29 at commit 6e0e950154a4c6983d9e077ed052298ad9126144
# the original version is slow with efs and other slow file systems
# even when blacklisting them, I could not find the exact cause
# but my fork foregoes parsing as long as there are keys in the input queue
#antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle dkuettel/zsh-syntax-highlighting
# note: should be the last to source, with antigen that is not so easily controlled

antigen apply


### configure bundles

# configure per-directory-history
# per-directory-history
#_per-directory-history-set-global-history # global by default
#bindkey -M vicmd ',g' per-directory-history-toggle-history
#bindkey -M viins '^xg' per-directory-history-toggle-history
#bindkey -M vicmd '^g' per-directory-history-toggle-history
#bindkey -M viins '^g' per-directory-history-toggle-history

# configure history-search-multi-word
#bindkey -M vicmd '^r' history-search-multi-word
#bindkey -M viins '^r' history-search-multi-word

# configure zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/efs)
ZSH_HIGHLIGHT_MAXLENGTH=2000
