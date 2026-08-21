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

alias mv='mv -i'
alias rm='rm -i'

alias ld='lazydocker'
alias lg='lazygit'
alias lsql='lazysql'
alias nv='nvim'

# クリップボードへコピー
alias yb='echo -n "$(git branch --show-current)" | pbcopy && echo "Copied branch: $(git branch --show-current)"'
alias yf='echo -n "$(pwd)" | pbcopy && echo "Copied full path: $(pwd)"'
alias yg='echo -n "$(git rev-parse --show-prefix | sed "s:/$::")" | pbcopy && echo "Copied git-relative path: $(git rev-parse --show-prefix | sed "s:/$::")"'

# cd後に自動でllを実行
chpwd() { ll }
