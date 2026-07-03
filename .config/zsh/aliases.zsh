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

alias dc='show_command docker compose'
alias dcb='show_command docker compose build'
alias dcd='show_command docker compose down'
alias dce='show_command docker compose exec'
alias dcr='show_command docker compose run'
alias dcu='show_command docker compose up'
alias dstopall='show_command docker container stop $(docker container ls -aq)'

alias be='bundle exec'
alias bi='bundle install'

alias -g C='| pbcopy'
alias -g F='| fzf'
alias -g G='| grep'

# クリップボードへコピー
alias yb='echo -n "$(git branch --show-current)" | pbcopy && echo "Copied branch: $(git branch --show-current)"'
alias yf='echo -n "$(pwd)" | pbcopy && echo "Copied full path: $(pwd)"'
alias yg='echo -n "$(git rev-parse --show-prefix | sed "s:/$::")" | pbcopy && echo "Copied git-relative path: $(git rev-parse --show-prefix | sed "s:/$::")"'
