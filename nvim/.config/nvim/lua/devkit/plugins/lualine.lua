return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",            -- load after UI is ready (and after colorscheme)
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
  },
  config = function()
    require("gitsigns").setup()
    require("lualine").setup({
      options = {
        theme = "auto",          -- now picks up your active scheme
        globalstatus = true,
        always_divide_middle = false,
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
      },
      sections = {
        lualine_a = { { "mode", fmt = function(s) return " " .. s end } },
        lualine_b = {
          "branch",
          { "diff", source = require("gitsigns").diff_source },
        },
        lualine_c = { "filename" },
        lualine_x = {
          { "diagnostics", sources = { "nvim_diagnostic" } }, -- modern source
          "encoding", "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {}, lualine_b = {}, lualine_c = { "filename" },
        lualine_x = {}, lualine_y = {}, lualine_z = {},
      },
    })
  end,
}
