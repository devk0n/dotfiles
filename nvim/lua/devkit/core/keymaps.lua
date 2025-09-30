-- Shorthands
local g = vim.g
local keymap = vim.keymap
-- local opts = { noremap = true, silent = true }

-- Leaders
g.mapleader = " "
g.maplocalleader = " "

-- Movement (visual mode)
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Editing
keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })
keymap.set("v", "p", '"_dp', { desc = "Paste without overwriting register" })
keymap.set("n", "x", '"_x', { desc = "Delete character (no yank)" })

-- Search
keymap.set("n", "n", "nzzzv", { desc = "Next match (centered)" })
keymap.set("n", "N", "Nzzzv", { desc = "Prev match (centered)" })
keymap.set("n", "<Esc>", ":nohl<CR>", { desc = "Clear search highlight", noremap = true, silent = true })

-- Autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
   desc = "Highlight on yank",
   group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
   callback = function()
      vim.highlight.on_yank()
   end,
})
