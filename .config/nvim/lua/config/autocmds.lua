-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- platetech の案件は自動フォーマットを切る
local platetech = vim.fs.normalize("~/workspace/github.com/platetech") .. "/"

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("platetech_no_autoformat", { clear = true }),
  desc = "保存時の自動フォーマットを無効化する",
  callback = function(event)
    local file = vim.api.nvim_buf_get_name(event.buf)
    if file ~= "" and vim.startswith(vim.fs.normalize(file), platetech) then
      vim.b[event.buf].autoformat = false
    end
  end,
})
