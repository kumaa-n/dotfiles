# PATH/fpath に重複を入れない
typeset -U path PATH fpath FPATH

export ZDOTDIR="$HOME/.config/zsh"
export LANG=ja_JP.UTF-8
export VISUAL=nvim
export EDITOR=$VISUAL
export PATH="$HOME/.local/bin:$PATH"

[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
