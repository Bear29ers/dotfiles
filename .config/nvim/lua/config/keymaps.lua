-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Resize window with Meta (Alt) + hjkl
map("n", "<M-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<M-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<M-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
