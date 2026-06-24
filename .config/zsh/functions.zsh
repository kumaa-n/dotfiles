command_exists() {
  command -v "$1" >/dev/null 2>&1;
}

show_command() {
    echo "=> $*"
    "$@"
}

# マージ済みローカルブランチ削除
gbdm() {
  local base="${1:-main}"
  git switch "$base" || return 1
  git branch --merged "$base" | grep -vE '^\*|master$|main$|milestone$|develop$' | xargs -I % git branch -d %
}

# mkdirしてcd（--は引数の先頭が-で始まる場合の対策）
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

nvzsh() {
  # サブシェル内で移動するため元のカレントディレクトリは維持される
  (
    cd ~/.config/zsh || exit
    nvim .
  )

  source ~/.zshrc
}

# 天気予報
wtr() { curl "https://ja.wttr.in/$1?2nF"; }
