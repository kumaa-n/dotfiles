command_exists() {
  command -v "$1" >/dev/null 2>&1;
}

# マージ済みローカルブランチ削除
gbdm() {
  local base="${1:-main}"
  git switch "$base" || return 1

  git branch --merged "$base" --format='%(refname:short)' |
    grep -vE '^(master|main|milestone|develop)$' |
    xargs -r git branch -d
}

# mkdirしてcd（--は引数の先頭が-で始まる場合の対策）
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

nvzsh() {
  # サブシェル内で移動するため元のカレントディレクトリは維持される
  (
    cd ~/.config/zsh || exit
    nvim .
  )

  source "$ZDOTDIR/.zshrc"
}

# 天気予報
wtr() { curl "https://ja.wttr.in/$1?2nF"; }
