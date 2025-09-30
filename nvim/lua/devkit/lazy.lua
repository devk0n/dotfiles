-- ~/.config/nvim/init.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
   })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
   defaults = { version = "*" },
   spec = {
      { import = "devkit.plugins" }, -- your plugins
   },
   checker = {
      enabled = true, -- automatically check for plugin updates
      notify = false,
   },
   change_detection = {
      enabled = true, -- reload config when files change
      notify = false,
   },
   rocks = {
      enabled = false, -- disable luarocks (you probably don’t need it)
   },
})
