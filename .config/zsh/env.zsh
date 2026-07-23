PS1='%n@%1~ %#'

# $EDITOR からキーマップを推測するので明示的に指定
bindkey -e

# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=20000
SAVEHIST=100000

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# 補完
fpath=($ZDOTDIR/completion $fpath)
autoload -Uz compinit
compinit
