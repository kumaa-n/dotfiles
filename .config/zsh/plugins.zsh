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

# starship/zsh-autosuggestions 等が zle-keymap-select をラップすることで
# FUNCNEST エラーが起きるため、全プラグイン読み込み後に上書きする
# bindkey -v (viモード) のキーマップ切り替え時にプロンプトを再描画する
function zle-keymap-select {
  zle reset-prompt
}
zle -N zle-keymap-select
