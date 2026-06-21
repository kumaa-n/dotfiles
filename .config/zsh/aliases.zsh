alias ..='cd ..'
alias ...='cd ../..'

if command_exists bat; then
  alias cat='bat'
fi

if command_exists eza; then
  alias ls='eza -F --icons --group-directories-first'
  alias ll='eza -alF --icons --group-directories-first --git'
  alias lt='eza --tree --level=2 --icons'
else
  alias ls='ls -F --color=auto'
  alias ll='ls -alF --color=auto'
fi

alias nv='nvim'

alias mv='mv -i'
alias rm='rm -i'

alias ld='lazydocker'
alias lg='lazygit'

alias dc='docker compose'
alias dcb='docker compose build'
alias dcd='docker compose down'
alias dce='docker compose exec'
alias dcr='docker compose run'
alias dcu='docker compose up'
alias dstopall='docker container stop $(docker container ls -aq)'

alias be='bundle exec'
alias bi='bundle install'

alias -g C='| pbcopy'
alias -g F='| fzf'
alias -g G='| grep'

# 現在のブランチ名をクリップボードにコピー
alias yb='git branch --show-current | pbcopy && echo "Copied branch: $(git branch --show-current)"'

# カレントディレクトリのgitルートからの相対パスをクリップボードにコピー
alias yg='echo -n "$(git rev-parse --show-prefix | sed "s:/$::")" | pbcopy && echo "Copied git-relative path: $(git rev-parse --show-prefix | sed "s:/$::")"'

# カレントディレクトリの絶対パスをクリップボードにコピー
alias yf='echo -n "$(pwd)" | pbcopy && echo "Copied full path: $(pwd)"'
