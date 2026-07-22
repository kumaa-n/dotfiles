#!/usr/bin/env zsh

# 下記内容でシンボリックリンクを安全に作成する
#   - 既に正しいリンク          → 何もしない
#   - 別の場所を指すリンク      → 貼り直す（消すのはリンク本体だけ。実データは無事）
#   - 実ファイル/実ディレクトリ → 触らずスキップして警告（勝手に上書きしない）
#   - 何も無い                  → 新しく作る
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
mkdir -p ~/.zsh

link ~/.dotfiles/.zshenv ~/.zshenv
link ~/.dotfiles/.config/git ~/.config/git
link ~/.dotfiles/.config/wezterm ~/.config/wezterm
link ~/.dotfiles/.config/starship.toml ~/.config/starship.toml
link ~/.dotfiles/.config/nvim ~/.config/nvim
link ~/.dotfiles/.config/zsh ~/.config/zsh
link ~/.dotfiles/.zsh/completion ~/.zsh/completion
