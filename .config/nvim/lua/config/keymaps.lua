-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Window resize with arrow keys
vim.keymap.set("n", "<C-S-h>", "<C-w><", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-S-l>", "<C-w>>", { desc = "Increase window width" })
vim.keymap.set("n", "<C-S-j>", "<C-w>+", { desc = "Increase window height" })
vim.keymap.set("n", "<C-S-k>", "<C-w>-", { desc = "Decrease window height" })
