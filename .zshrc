export LANG=ja_JP.UTF-8
export EDITOR=nvim
export PS1='%n@%1~ %#'

export PATH="$HOME/.local/bin:$PATH"

# history関連
HISTSIZE=100000
SAVEHIST=100000

# alias設定
alias ..='cd ..'
alias ...='cd ../..'
alias cat='bat'
alias ls='eza --icons --group-directories-first'
alias ll='eza -alF --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'
alias nv='nvim'
alias mv='mv -i'
alias rm='rm -i'
alias nvzsh='nvim ~/.zshrc && source ~/.zshrc'

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
alias bi='bundle install'

# History Beginning Search
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# マージ済みローカルブランチ削除
gbdm() {
  local base="${1:-main}"
  git switch "$base" || return 1
  git branch --merged "$base" | grep -vE '^\*|master$|main$|milestone$|develop$' | xargs -I % git branch -d %
}

# mkdirしてcd（--は引数の先頭が-で始まる場合の対策）
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# 天気予報
wtr() { curl "https://ja.wttr.in/$1?2nF"; }

# 補完
autoload -Uz compinit
compinit

# mise
eval "$(mise activate zsh --shims)"

# starship
eval "$(starship init zsh)"

# zoxide
if [[ $- == *i* ]]; then
  eval "$(zoxide init zsh --cmd j)"
  alias cd='j'
  alias cdi='ji'
fi

# zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
