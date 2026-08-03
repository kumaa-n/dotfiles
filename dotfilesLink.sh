#!/usr/bin/env zsh

# シンボリックリンクを作成
link() {
  local src=$1 dest=$2

  if [[ -L $dest ]]; then
    [[ "$(readlink "$dest")" == "$src" ]] && return

    rm "$dest" && ln -s "$src" "$dest" && echo "relinked: $dest"
  elif [[ -e $dest ]]; then
    echo "skip: $dest は既に存在します。手動で内容を確認してください。"
  else
    ln -s "$src" "$dest" && echo "linked: $dest"
  fi
}

mkdir -p ~/.config

link ~/dotfiles/.zshenv ~/.zshenv
link ~/dotfiles/.config/git ~/.config/git
link ~/dotfiles/.config/wezterm ~/.config/wezterm
link ~/dotfiles/.config/starship.toml ~/.config/starship.toml
link ~/dotfiles/.config/nvim ~/.config/nvim
link ~/dotfiles/.config/zsh ~/.config/zsh
link ~/dotfiles/.config/yazi ~/.config/yazi
