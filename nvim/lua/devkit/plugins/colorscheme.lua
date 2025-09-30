return {
   {
      "catppuccin/nvim",
      priority = 1000,
      config = function()
         vim.cmd("colorscheme catppuccin-macchiato")

         -- Link virtual text highlights to sign colors (no background)
         vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticSignError" })
         vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { link = "DiagnosticSignWarn" })
         vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticSignInfo" })
         vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "DiagnosticSignHint" })
      end,
   },
}
