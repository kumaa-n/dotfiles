# alias設定
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias -g C='| pbcopy'
alias -g F='| fzf'
alias -g G='| grep'
alias nv='nvim'
alias vi='vim'
alias mv='mv -i'
alias rm='rm -i'

alias ld='lazydocker'
alias dc='docker compose'
alias dcb='docker compose build'
alias dcd='docker compose down'
alias dce='docker compose exec'
alias dcr='docker compose run'
alias dcu='docker compose up'
alias dstopall='docker container stop $(docker container ls -aq)'

alias lg='lazygit'

alias be='bundle exec'

# ターミナル
export PS1='%n@%1~ %#'

# git補完
fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit -u

# history関連
HISTSIZE=100000
SAVEHIST=100000

# History Beginning Search
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# Python
export PYENV_ROOT="$HOME/.pyenv_x86"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# starship
eval "$(starship init zsh)"

# Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
