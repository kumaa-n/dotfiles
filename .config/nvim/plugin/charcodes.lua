-- バイト列を "E3 81 82" のような16進文字列にする
local function hex(s)
  if s == nil or s == "" then
    return "(変換不可)"
  end
  local out = s:gsub(".", function(c)
    return string.format("%02X ", c:byte())
  end)
  return (out:gsub("%s+$", ""))
end

-- iconv で変換し16進を返す。変換できない文字は "?"(0x3F) に化けるので、
-- 逆変換して元に戻らなければ「変換不可」とみなす（例: 𠮷 や絵文字を SJIS/EUC へ）
local function via_iconv(ch, enc)
  local r = vim.fn.iconv(ch, "utf-8", enc)
  if r == nil or r == "" then
    return "(変換不可)"
  end
  if vim.fn.iconv(r, enc, "utf-8") ~= ch then
    return "(変換不可)"
  end
  return hex(r)
end

-- JIS(ISO-2022-JP)は前後にエスケープシーケンスが付くので、純粋なコードだけ取り出す
local function to_jis(ch)
  local r = vim.fn.iconv(ch, "utf-8", "iso-2022-jp")
  if r == nil or r == "" then
    return "(変換不可)"
  end
  if vim.fn.iconv(r, "iso-2022-jp", "utf-8") ~= ch then
    return "(変換不可)"
  end
  -- ESC $ @ / ESC $ B（漢字IN）, ESC ( B / ESC ( J / ESC ( I（OUT）を除去
  r = r:gsub("\27%$[@B]", ""):gsub("\27%([BJI]", "")
  return hex(r)
end

-- UTF-16 は Neovim の iconv() が非対応なので、コードポイントから自前で計算する
-- （U+FFFF超はサロゲートペアで4バイトになる）
local function utf16(cp, big_endian)
  local units
  if cp <= 0xFFFF then
    units = { cp }
  else
    local c = cp - 0x10000
    units = { 0xD800 + math.floor(c / 0x400), 0xDC00 + (c % 0x400) }
  end
  local bytes = {}
  for _, u in ipairs(units) do
    local hi, lo = math.floor(u / 256), u % 256
    if big_endian then
      table.insert(bytes, string.format("%02X", hi))
      table.insert(bytes, string.format("%02X", lo))
    else
      table.insert(bytes, string.format("%02X", lo))
      table.insert(bytes, string.format("%02X", hi))
    end
  end
  return table.concat(bytes, " ")
end

local encodings = {
  { "UTF-8", "utf-8" },
  { "UTF-16BE", "utf-16be" },
  { "UTF-16LE", "utf-16le" },
  { "CP932", "cp932" },
  { "EUC-JP", "euc-jp" },
  { "JIS", "iso-2022-jp" },
}

-- 1文字分の情報を行のリストで返す
local function char_lines(ch)
  local cp = vim.fn.char2nr(ch)
  local lines = {
    "文字: " .. ch,
    string.format("  %-10s : U+%04X", "Unicode", cp),
  }
  for _, e in ipairs(encodings) do
    local label, enc = e[1], e[2]
    local val
    if enc == "iso-2022-jp" then
      val = to_jis(ch)
    elseif enc == "utf-8" then
      val = hex(ch) -- Neovim内部はUTF-8なのでそのまま
    elseif enc == "utf-16be" then
      val = utf16(cp, true)
    elseif enc == "utf-16le" then
      val = utf16(cp, false)
    else
      val = via_iconv(ch, enc)
    end
    table.insert(lines, string.format("  %-10s : %s", label, val))
  end
  table.insert(lines, string.format("  %-10s : &#%d;", "HTML(10進)", cp))
  table.insert(lines, string.format("  %-10s : &#x%X;", "HTML(16進)", cp))
  return lines
end

-- 直前に開いたパネルを覚えておき、開き直すときは閉じる
local panel_win = nil

-- 行リストを中央のスクロール可能なパネルで表示（1文字・範囲選択の両方で使う）
-- noice のメッセージ経路を通らないので "lua_print" などのラベルが付かない。q / Esc で閉じる
local function show_panel(lines)
  if panel_win and vim.api.nvim_win_is_valid(panel_win) then
    vim.api.nvim_win_close(panel_win, true)
  end
  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  local max_h = math.max(1, math.floor(vim.o.lines * 0.8))
  local height = math.min(#lines, max_h)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "charcodes"
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = math.floor((vim.o.lines - height) / 2 - 1),
    col = math.floor((vim.o.columns - (width + 2)) / 2),
    width = width + 1,
    height = height,
    style = "minimal",
    border = "rounded",
    title = " CharCodes ",
    title_pos = "center",
  })
  panel_win = win
  vim.wo[win].cursorline = true
  for _, key in ipairs({ "q", "<Esc>" }) do
    vim.keymap.set("n", key, function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end, { buffer = buf, nowait = true, silent = true })
  end
end

-- カーソル下の1文字を表示
local function show_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col(".")
  local ch = vim.fn.matchstr(line, ".", col - 1)
  if ch == "" then
    vim.notify("charcodes: 文字がありません", vim.log.levels.WARN)
    return
  end
  show_panel(char_lines(ch))
end

-- ビジュアル選択した文字すべてを表示
local function show_visual()
  local save, savetype = vim.fn.getreg('"'), vim.fn.getregtype('"')
  vim.cmd('noautocmd normal! ""y')
  local sel = vim.fn.getreg('"')
  vim.fn.setreg('"', save, savetype)
  if sel == "" then
    return
  end
  local lines = {}
  local first = true
  for _, ch in ipairs(vim.fn.split(sel, "\\zs")) do
    if ch ~= "\n" then
      if not first then
        table.insert(lines, "")
      end
      first = false
      for _, l in ipairs(char_lines(ch)) do
        table.insert(lines, l)
      end
    end
  end
  show_panel(lines)
end

vim.api.nvim_create_user_command("CharCodes", show_cursor, { desc = "Show char codes (char under cursor)" })
vim.keymap.set("n", "<Leader>C", show_cursor, { desc = "Show char codes (char under cursor)" })
vim.keymap.set("x", "<Leader>C", show_visual, { desc = "Show char codes (each char in selection)" })
