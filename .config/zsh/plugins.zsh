# mise
eval "$(mise activate zsh --shims)"

# starship
eval "$(starship init zsh)"

# zoxide
if [[ $- == *i* ]] && command_exists zoxide; then
  eval "$(zoxide init zsh --cmd j)"
  alias cd='j'
  alias cdi='ji'
fi

# antidote
# 管理するプラグインは .zsh_plugins.txt に記述する
antidote_dir=/usr/local/share/antidote
[[ -d $antidote_dir ]] || antidote_dir=/opt/homebrew/share/antidote
source "$antidote_dir/antidote.zsh"
antidote load "${ZDOTDIR:-$HOME/.config/zsh}/.zsh_plugins.txt"

# zsh-abbr
abbr -S -qq dcb='docker compose build'
abbr -S -qq dcd='docker compose down'
abbr -S -qq dce='docker compose exec'
abbr -S -qq dcr='docker compose run'
abbr -S -qq dcu='docker compose up'
abbr -S -qq dstopall='docker container stop $(docker container ls -aq)'
abbr -S -qq -g bue='bundle exec'
abbr -S -qq -g bui='bundle install'
abbr -S -qq -g C='| pbcopy'
abbr -S -qq -g F='| fzf'
abbr -S -qq -g G='| grep'
