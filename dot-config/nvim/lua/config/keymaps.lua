-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- source vim config
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- in visual mode, move selected line down or up
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- in visual mode, does NOT overwrite your clipboard and paste the content of clipboard
vim.keymap.set("x", "<leader>p", [["_dP]])

-- don't put deleted selection to clipboard
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- indent paragraph with cursor stays in place
vim.keymap.set("n", "=ap", "ma=ap'a")

-- next search keeps cursor centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- scroll in insert mode
vim.keymap.set("i", "<C-E>", "<C-X><C-E>", { silent = true })
vim.keymap.set("i", "<C-Y>", "<C-X><C-Y>", { silent = true })
