-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.conceallevel = 0 -- LazyVim の 2 を無効化（編集中に ``` 等が隠れるのを防ぐ）

-- タブとスペースを視覚化
vim.opt.listchars = {
  tab = "▸ ",
  lead = "·",
  trail = "·",
  nbsp = "␣",
  extends = "❯",
  precedes = "❮",
}
