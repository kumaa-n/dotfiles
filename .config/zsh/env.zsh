export LANG=ja_JP.UTF-8
export EDITOR=nvim
export PS1='%n@%1~ %#'

export PATH="$HOME/.local/bin:$PATH"

# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# History Beginning Search
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# 補完
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit
compinit
