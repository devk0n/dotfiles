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
keymap.set("n", "J", "mzJ`z", { desc = "Join line below (keep cursor)" })
keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })
keymap.set("v", "p", '"_dp', { desc = "Paste without overwriting register" })
keymap.set("n", "x", '"_x', { desc = "Delete character (no yank)" })

-- Search
keymap.set("n", "n", "nzzzv", { desc = "Next match (centered)" })
keymap.set("n", "N", "Nzzzv", { desc = "Prev match (centered)" })
keymap.set("n", "<Esc>", ":nohl<CR>", { desc = "Clear search highlight", noremap = true, silent = true })

-- Indentation (visual mode)
keymap.set("v", ">", ">gv", { desc = "Indent right (stay in selection)" })
keymap.set("v", "<", "<gv", { desc = "Indent left (stay in selection)" })

-- Substitution
keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
  desc = "Substitute word under cursor (buffer-wide)",
})

-- Autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
