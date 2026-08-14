-- HTML/JSX/Vue/Svelte/ERB/Twig/Blade から class / id を集めて CSS セレクターの雛形をコピーする
--
-- 対応する書き方:
--   class="a b"  class='a b'                     HTML
--   className="a b"  className={...}             React/JSX
--   :class="..."  v-bind:class="..."             Vue (オブジェクト/配列記法も)
--   class:active={...}                           Svelte ディレクティブ
--   { class: "a b" }  { className: "a b" }       JS オブジェクトのプロパティ
--   class: "a b"  :class => "a b"                Ruby / ERB ヘルパー
--   class="btn <%= ... %>"                       ERB
--   class="btn {{ ... }}{% ... %}"               Twig / Blade
--   @class(['btn', 'active' => $x])              Blade
--   id="x"  id={...}  { id: "x" }
--
-- 式 ({...} や <%= %> の中) は「文字列リテラル」と「オブジェクトのキー」を拾う。
--   clsx("btn", on && "active")   -> .btn .active
--   clsx({ active: on })          -> .active
--   `p-4 ${size} border`          -> .p-4 .border (${...} の中の文字列も再帰的に拾う)
--   styles.foo                    -> 何も拾わない

local OPEN = { ["{"] = "}", ["["] = "]", ["("] = ")" }
local INVALID_CHARS = "{}()[]<>\"'`\\&|?;,=$*+!~^@%#"

-- テンプレートエンジンの埋め込み記法。長い open から先に判定する。
-- expr: 中身を式として解析するか / glue: 出力タグ (前後の文字列と連結される) か
local TEMPLATE_TAGS = {
  { open = "{{--", close = "--}}", expr = false, glue = false }, -- Blade コメント
  { open = "{#", close = "#}", expr = false, glue = false }, -- Twig コメント
  { open = "{!!", close = "!!}", expr = true, glue = true }, -- Blade (エスケープなし)
  { open = "{{{", close = "}}}", expr = true, glue = true },
  { open = "{{", close = "}}", expr = true, glue = true }, -- Twig / Blade / Mustache
  { open = "{%", close = "%}", expr = true, glue = false }, -- Twig タグ
  { open = "<%=", close = "%>", expr = true, glue = true }, -- ERB (出力あり)
  { open = "<%-", close = "%>", expr = true, glue = false },
  { open = "<%", close = "%>", expr = true, glue = false }, -- ERB (出力なし)
}

local string_end, balanced_end, collect_from_expr, collect_from_template, collect_from_attr_text

--- i は引用符の位置。閉じ引用符の位置を返す
string_end = function(text, i)
  local quote = text:sub(i, i)
  local j = i + 1
  while j <= #text do
    local ch = text:sub(j, j)
    if ch == "\\" then
      j = j + 2
    elseif ch == quote then
      return j
    elseif quote == "`" and ch == "$" and text:sub(j + 1, j + 1) == "{" then
      j = balanced_end(text, j + 1) + 1
    else
      j = j + 1
    end
  end
  return #text
end

--- i は開き括弧の位置。対応する閉じ括弧の位置を返す
balanced_end = function(text, i)
  local stack = { OPEN[text:sub(i, i)] }
  local j = i + 1
  while j <= #text and #stack > 0 do
    local ch = text:sub(j, j)
    if ch == '"' or ch == "'" or ch == "`" then
      j = string_end(text, j) + 1
    elseif OPEN[ch] then
      table.insert(stack, OPEN[ch])
      j = j + 1
    elseif ch == stack[#stack] then
      table.remove(stack)
      j = j + 1
    else
      j = j + 1
    end
  end
  return j - 1
end

local function is_valid_name(token)
  if token == nil or token == "" then
    return false
  end
  for i = 1, #token do
    if INVALID_CHARS:find(token:sub(i, i), 1, true) then
      return false
    end
  end
  return true
end

--- glue_left/glue_right は、その端が補間 (${...} や {{ ... }}) と空白なしで
--- 繋がっていることを表す。`btn-${size}` の "btn-" のような断片は捨てる
local function split_names(str, add, glue_left, glue_right)
  if glue_left and not str:match("^%s") then
    str = str:gsub("^%S+", "", 1)
  end
  if glue_right and not str:match("%s$") then
    str = str:gsub("%S+$", "", 1)
  end
  for name in str:gmatch("%S+") do
    add(name)
  end
end

local function has_template_tag(str)
  for _, tag in ipairs(TEMPLATE_TAGS) do
    if str:find(tag.open, 1, true) then
      return true
    end
  end
  return false
end

--- 式のソース (JSX の {}、<%= %> の中身、関数の引数、配列など) から名前を集める
collect_from_expr = function(src, add)
  for key in src:gmatch("[{,]%s*([%a_$][%w_$%-]*)%s*:") do
    add(key)
  end

  local i = 1
  while i <= #src do
    local ch = src:sub(i, i)
    if ch == '"' or ch == "'" then
      local e = string_end(src, i)
      split_names(src:sub(i + 1, e - 1), add)
      i = e + 1
    elseif ch == "`" then
      local e = string_end(src, i)
      collect_from_template(src:sub(i + 1, e - 1), add)
      i = e + 1
    else
      i = i + 1
    end
  end
end

--- テンプレートリテラルの中身。${...} の外は名前、中は式として扱う
collect_from_template = function(body, add)
  local i = 1
  local glued = false
  while i <= #body do
    local s = body:find("${", i, true)
    if not s then
      break
    end
    split_names(body:sub(i, s - 1), add, glued, true)
    local e = balanced_end(body, s + 1)
    collect_from_expr(body:sub(s + 2, e - 1), add)
    i = e + 1
    glued = true
  end
  split_names(body:sub(i), add, glued, false)
end

--- 埋め込み記法混じりの属性値。タグの外は名前、中は式として扱う
collect_from_attr_text = function(body, add)
  local i = 1
  local plain_from = 1
  local glued = false
  while i <= #body do
    local tag
    for _, candidate in ipairs(TEMPLATE_TAGS) do
      if body:sub(i, i + #candidate.open - 1) == candidate.open then
        tag = candidate
        break
      end
    end
    if tag then
      split_names(body:sub(plain_from, i - 1), add, glued, tag.glue)
      local inner_from = i + #tag.open
      local close_at = body:find(tag.close, inner_from, true)
      if tag.expr then
        collect_from_expr(body:sub(inner_from, (close_at or #body + 1) - 1), add)
      end
      i = close_at and (close_at + #tag.close) or (#body + 1)
      plain_from = i
      glued = tag.glue
    else
      i = i + 1
    end
  end
  split_names(body:sub(plain_from), add, glued, false)
end

--- i は値の先頭。値を読み終えた次の位置を返す
local function collect_from_value(text, i, add)
  local ch = text:sub(i, i)
  if ch == '"' or ch == "'" or ch == "`" then
    local e = string_end(text, i)
    local body = text:sub(i + 1, e - 1)
    local head = body:match("^%s*(.)")
    if ch == "`" then
      collect_from_template(body, add)
    elseif has_template_tag(body) then
      collect_from_attr_text(body, add)
    elseif head == "{" or head == "[" then
      collect_from_expr(body, add) -- Vue の :class="{ a: b }" / "['a', b]"
    else
      split_names(body, add)
    end
    return e + 1
  elseif OPEN[ch] then
    local e = balanced_end(text, i)
    collect_from_expr(text:sub(i + 1, e - 1), add)
    return e + 1
  end
  return i
end

local function is_word_char(ch)
  return ch ~= "" and ch:match("[%w_$%-]") ~= nil
end

local function skip_ws(text, i)
  local _, e = text:find("^%s*", i)
  return e + 1
end

--- class / className / id の出現位置を、文書順に集める
local function find_keys(text)
  local hits = {}
  for _, key in ipairs({ "className", "class", "id" }) do
    local init = 1
    while true do
      local s, e = text:find(key, init, true)
      if not s then
        break
      end
      init = e + 1
      if not is_word_char(text:sub(s - 1, s - 1)) and not is_word_char(text:sub(e + 1, e + 1)) then
        table.insert(hits, { pos = s, stop = e, key = key })
      end
    end
  end
  table.sort(hits, function(a, b)
    return a.pos < b.pos
  end)
  return hits
end

local function build_selectors(lines)
  local text = table.concat(lines, "\n")
  local selectors = {}
  local seen = {}

  local function adder(prefix)
    return function(name)
      if not is_valid_name(name) then
        return
      end
      local selector = prefix .. name
      if not seen[selector] then
        seen[selector] = true
        table.insert(selectors, selector .. " {\n\n}")
      end
    end
  end
  local add_class = adder(".")
  local add_id = adder("#")

  local cursor = 1
  for _, hit in ipairs(find_keys(text)) do
    if hit.pos >= cursor then
      local add = hit.key == "id" and add_id or add_class
      local prev = text:sub(hit.pos - 1, hit.pos - 1)
      local after_key = hit.stop + 1
      -- "class" => "x" / { 'class': 'x' } のように引用符で括られたキー
      if (prev == '"' or prev == "'") and text:sub(after_key, after_key) == prev then
        after_key = after_key + 1
      end

      local i = skip_ws(text, after_key)
      local ch = text:sub(i, i)
      if ch == "=" and text:sub(i + 1, i + 1) ~= "=" then
        i = i + 1
        if text:sub(i, i) == ">" then -- Ruby のハッシュロケット
          i = i + 1
        end
        cursor = collect_from_value(text, skip_ws(text, i), add)
      elseif ch == ":" then
        local following = text:sub(i + 1, i + 1)
        if hit.key == "class" and i == hit.stop + 1 and following:match("[%a_]") then
          -- Svelte の class:active={...}
          local name = text:match("^([%w_%-]+)", i + 1)
          add_class(name)
          cursor = i + 1 + #name
        else
          cursor = collect_from_value(text, skip_ws(text, i + 1), add)
        end
      elseif ch == "(" and prev == "@" then
        -- Blade の @class([...])
        cursor = collect_from_value(text, i, add)
      end
    end
  end

  if #selectors == 0 then
    vim.notify("class/id が見つかりませんでした", vim.log.levels.WARN)
    return
  end

  vim.fn.setreg("+", table.concat(selectors, "\n\n"))
  vim.notify(#selectors .. " 件のセレクターをコピーしました", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("HtmlExtract", function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
  build_selectors(lines)
end, { range = true })

vim.keymap.set(
  "n",
  "<leader>hx",
  "<cmd>%HtmlExtract<CR>",
  { desc = "Extract HTML class/id as CSS selectors (whole buffer)" }
)
vim.keymap.set("v", "<leader>hx", ":HtmlExtract<CR>", { desc = "Extract HTML class/id as CSS selectors (selection)" })
