-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Window resize with arrow keys
vim.keymap.set("n", "<C-S-h>", "<C-w><", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-S-l>", "<C-w>>", { desc = "Increase window width" })
vim.keymap.set("n", "<C-S-j>", "<C-w>+", { desc = "Increase window height" })
vim.keymap.set("n", "<C-S-k>", "<C-w>-", { desc = "Decrease window height" })

-- Yank
vim.keymap.set("n", "<leader>y", "", { desc = "Yank" })

-- Yank git-relative path
vim.keymap.set("n", "<leader>yg", function()
  local prefix = vim.fn.system("git rev-parse --show-prefix"):gsub("\n", "")
  local path = prefix .. vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  print("Copied git-relative path: " .. path)
end, { desc = "Yank git-relative path" })

-- Yank full path
vim.keymap.set("n", "<leader>yf", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("Copied full path: " .. path)
end, { desc = "Yank full path" })

-- Yank current branch name
vim.keymap.set("n", "<leader>yb", function()
  local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
  vim.fn.setreg("+", branch)
  print("Copied branch: " .. branch)
end, { desc = "Yank branch name" })
