-- Shorthands
local g = vim.g
local map = vim.keymap.set

-- Leaders
g.mapleader = " "
g.maplocalleader = " "

-- Search
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev match (centered)" })
map("n", "*", "*zzzv", { desc = "Search word forward (centered)" })
map("n", "#", "#zzzv", { desc = "Search word backward (centered)" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Editing
map({ "v", "x" }, "p", '"_dP', { desc = "Paste without overwriting register", noremap = true, silent = true, })

-- Move selected lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down", noremap = true, silent = true, })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up", noremap = true, silent = true, })

-- Get quickfix list safely
local function qf_has_items()
   return #vim.fn.getqflist() > 0
end

local function qf_cycle_next()
   if not qf_has_items() then
      vim.notify("Quickfix list is empty", vim.log.levels.WARN)
      return
   end
   local ok = pcall(vim.cmd, "cnext")
   if not ok then
      vim.cmd("cfirst") -- wrap if at end
   end
end

local function qf_cycle_prev()
   if not qf_has_items() then
      vim.notify("Quickfix list is empty", vim.log.levels.WARN)
      return
   end
   local ok = pcall(vim.cmd, "cprev")
   if not ok then
      vim.cmd("clast") -- wrap if at start
   end
end

vim.keymap.set("n", "]q", qf_cycle_next, { desc = "Next quickfix (wrap)" })
vim.keymap.set("n", "[q", qf_cycle_prev, { desc = "Prev quickfix (wrap)" })

-- Autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
   desc = "Highlight on yank",
   group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
   callback = function()
      vim.hl.on_yank()
   end,
})
