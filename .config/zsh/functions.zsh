command_exists() {
  command -v "$1" >/dev/null 2>&1;
}

# マージ済みローカルブランチ削除（merge commit で統合されたものが対象）
gbdm() {
  local base="${1:-main}"
  git switch "$base" || return 1
  git pull --ff-only --quiet || return 1

  git branch --merged "$base" --format='%(refname:short)' |
    grep -vE '^(master|main|milestone|develop)$' |
    xargs -r git branch -d
}

# リモートで削除されたローカルブランチを削除（squash / rebase merge 対応）
gbdg() {
  git fetch --prune --quiet || return 1

  local -a targets
  targets=(${(f)"$(git branch -vv | awk '/: gone]/ && $1 != "*" { print $1 }')"})
  (( $#targets )) || { echo "整理対象はありません"; return 0 }

  echo "削除候補:"
  printf '  %s\n' $targets
  read -q "?削除しますか？ [y/N] " || { echo; return 1 }
  echo
  git branch -D $targets
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
