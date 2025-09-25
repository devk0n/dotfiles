require("devkit.core")
require("devkit.lsp")
require("devkit.lazy")

vim.opt.shell = "/bin/zsh -i"

-- Disable background colors in Neovim
vim.cmd([[
  hi Normal guibg=none
  hi NormalNC guibg=none
  hi SignColumn guibg=none
  hi LineNr guibg=none
  hi EndOfBuffer guibg=none
]])

