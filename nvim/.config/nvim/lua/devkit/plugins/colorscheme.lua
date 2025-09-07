return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
      })

      vim.cmd("colorscheme gruvbox")

      -- Fix floating windows (Oil.nvim, Telescope, etc.)
      vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
      vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
    end,
  },
}
