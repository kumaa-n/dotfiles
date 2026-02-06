# alias設定
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias nv='nvim'
alias vi='vim'
alias mv='mv -i'
alias rm='rm -i'
alias nvimzsh='nvim ~/.zshrc && source ~/.zshrc'

alias -g C='| pbcopy'
alias -g F='| fzf'
alias -g G='| grep'

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

# History Beginning Search
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# マージ済みローカルブランチ削除
gbdm() {
  git checkout $1
  git branch --merged $1 | grep -vE '^\*|master$|main$|milestone$|develop$' | xargs -I % git branch -d %
}

# mkdirしてcd（--は引数の先頭が-で始まる場合の対策）
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# ターミナル
export PS1='%n@%1~ %#'

# history関連
HISTSIZE=100000
SAVEHIST=100000

# git補完
fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit -u

# Python
export PYENV_ROOT="$HOME/.pyenv_x86"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# starship
eval "$(starship init zsh)"

# Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
