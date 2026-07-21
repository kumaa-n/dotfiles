# no-touch: 触ってはいけないファイル/ディレクトリを開こうとしたら警告する
#
# 使い方:
#   notouch list            # リスト表示
#   notouch add <path> [理由]
#   notouch rm  <path>
#   notouch check <path>    # そのパスがブロック対象か確認
#   notouch edit            # リストを直接編集
#   notouch off / on        # このシェルだけ一時的に無効化 / 再有効化
#
# 仕組み: nvim/vim/nano/code などのエディタを関数でラップし、
# 引数のパスがブロックリストに一致したら確認プロンプトを出す。
# 'yes' と入力したときだけ開ける。

: ${NOTOUCH_FILE:="$HOME/.config/no-touch/blocklist"}

# 監視対象のパスか判定する。一致したら 0 を返し、理由を NOTOUCH_REASON に入れる。
# シンボリックリンク解決前(:a) / 解決後(:A) の両方の絶対パスで照合するため、
# ~/.config/wezterm のようにリンク経由でも実体経由でも一致する。
__notouch_check_path() {
  emulate -L zsh
  setopt extended_glob
  local target_a="${1:a}" target_A="${1:A}"
  local line entry reason e t
  NOTOUCH_REASON=""
  [[ -r "$NOTOUCH_FILE" ]] || return 1
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%$'\r'}"
    # コメント行・空行はスキップ
    [[ "$line" == \#* ]] && continue
    [[ "$line" == [[:space:]]# ]] && continue
    # "パス  # 理由" を分割（extended_glob 下ではリテラル # をエスケープ）
    entry="${line%%\#*}"
    if [[ "$line" == *\#* ]]; then reason="${line#*\#}"; else reason=""; fi
    # 前後の空白を除去
    entry="${entry##[[:space:]]##}"; entry="${entry%%[[:space:]]##}"
    reason="${reason##[[:space:]]##}"; reason="${reason%%[[:space:]]##}"
    [[ -z "$entry" ]] && continue
    # 先頭の ~ を展開
    entry="${entry/#\~/$HOME}"
    # 照合するエントリの形（グロブを含まなければ実体パスも追加）
    local -a forms=("$entry")
    if [[ "$entry" != *[\*\?\[]* ]]; then forms+=("${entry:A}"); fi
    for e in $forms; do
      for t in "$target_a" "$target_A"; do
        if [[ "$t" == $e || "$t" == $e/* ]]; then
          NOTOUCH_REASON="$reason"
          return 0
        fi
      done
    done
  done < "$NOTOUCH_FILE"
  return 1
}

# エディタ起動をガードする本体
__notouch_guard() {
  emulate -L zsh
  setopt extended_glob
  local cmd="$1"; shift
  if [[ -n "$NOTOUCH_DISABLED" ]]; then
    command "$cmd" "$@"
    return
  fi
  local arg hit=""
  for arg in "$@"; do
    [[ "$arg" == -* ]] && continue    # オプション
    [[ "$arg" == +* ]] && continue    # vim の行番号指定など
    if __notouch_check_path "$arg"; then
      hit="${arg:a}"
      break
    fi
  done
  if [[ -n "$hit" ]]; then
    print -P "%F{red}%B⛔ no-touch: このパスは「触らないリスト」に入っています%b%f"
    print    "   対象: $hit"
    [[ -n "$NOTOUCH_REASON" ]] && print "   理由: $NOTOUCH_REASON"
    print -n "   それでも開きますか? 開くなら 'yes' と入力: "
    local ans
    read -r ans < "${NOTOUCH_TTY:-/dev/tty}"
    if [[ "${ans:l}" != "yes" ]]; then
      print -P "%F{yellow}   → キャンセルしました。よく我慢した。%f"
      return 1
    fi
    print -P "%F{yellow}   → 開きます。ほどほどにね。%f"
  fi
  command "$cmd" "$@"
}

# ガード対象のコマンド一覧（必要に応じて増減してOK）
for __nt_cmd in nvim vim vi nano emacs helix hx micro code cursor subl open; do
  if command -v "$__nt_cmd" >/dev/null 2>&1 || [[ "$__nt_cmd" == open ]]; then
    eval "${__nt_cmd}() { __notouch_guard ${__nt_cmd} \"\$@\"; }"
  fi
done
unset __nt_cmd

# 管理コマンド
notouch() {
  emulate -L zsh
  setopt extended_glob
  local sub="$1"; [[ $# -gt 0 ]] && shift
  case "$sub" in
    list|ls|"")
      if [[ -s "$NOTOUCH_FILE" ]]; then
        print -P "%F{cyan}触ってはいけないリスト%f ($NOTOUCH_FILE):"
        command cat "$NOTOUCH_FILE"
      else
        print "リストは空です ($NOTOUCH_FILE)"
      fi
      ;;
    add)
      local p="$1"; [[ $# -gt 0 ]] && shift
      local reason="$*"
      if [[ -z "$p" ]]; then print "usage: notouch add <path> [理由]"; return 1; fi
      p="${p:A}"
      mkdir -p "${NOTOUCH_FILE:h}"
      if [[ -n "$reason" ]]; then
        print -r -- "$p  # $reason" >> "$NOTOUCH_FILE"
      else
        print -r -- "$p" >> "$NOTOUCH_FILE"
      fi
      print -P "%F{green}追加:%f $p"
      ;;
    rm|remove|del)
      local p="$1"
      if [[ -z "$p" ]]; then print "usage: notouch rm <path>"; return 1; fi
      p="${p:A}"
      [[ -r "$NOTOUCH_FILE" ]] || { print "リストがありません"; return 1; }
      local tmp="${NOTOUCH_FILE}.tmp" line entry removed=0
      : > "$tmp"
      while IFS= read -r line || [[ -n "$line" ]]; do
        entry="${line%%\#*}"
        entry="${entry##[[:space:]]##}"; entry="${entry%%[[:space:]]##}"
        entry="${entry/#\~/$HOME}"
        if [[ "$entry" == "$p" ]]; then removed=1; continue; fi
        print -r -- "$line" >> "$tmp"
      done < "$NOTOUCH_FILE"
      command mv "$tmp" "$NOTOUCH_FILE"
      if [[ $removed -eq 1 ]]; then print -P "%F{green}削除:%f $p"; else print "一致する行はありませんでした: $p"; fi
      ;;
    check|test)
      local p="$1"
      if __notouch_check_path "$p"; then
        print -P "%F{red}🚫 ブロック対象:%f ${p:a} ${NOTOUCH_REASON:+（$NOTOUCH_REASON）}"
      else
        print -P "%F{green}✅ OK:%f ${p:a}"
      fi
      ;;
    edit)
      mkdir -p "${NOTOUCH_FILE:h}"
      command "${EDITOR:-nvim}" "$NOTOUCH_FILE"
      ;;
    off)
      export NOTOUCH_DISABLED=1
      print -P "%F{yellow}no-touch: このシェルで一時的に無効化しました（notouch on で復帰）%f"
      ;;
    on)
      unset NOTOUCH_DISABLED
      print -P "%F{green}no-touch: 有効化しました%f"
      ;;
    help|-h|--help|*)
      cat <<'EOF'
notouch - 触ってはいけないファイル/ディレクトリのガード

  notouch list             リストを表示
  notouch add <path> [理由]  リストに追加
  notouch rm  <path>        リストから削除
  notouch check <path>      そのパスがブロック対象か確認
  notouch edit              リストを直接編集
  notouch off / on          このシェルだけ一時的に無効化 / 復帰
EOF
      ;;
  esac
}
