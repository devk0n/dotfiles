return {
   "nvim-lualine/lualine.nvim",
   dependencies = {
      "nvim-tree/nvim-web-devicons",
      "lewis6991/gitsigns.nvim",
   },
   config = function()
      require("gitsigns").setup()

      require("lualine").setup({
         options = {
            theme = "auto",
            globalstatus = true,
            section_separators = "",
            component_separators = "",
            icons_enabled = true,
         },
         sections = {
            lualine_a = {
               {
                  "mode",
                  fmt = function(s)
                     return " " .. s
                  end,
                  color = { gui = "bold" },
               },
            },
            lualine_b = {
               { "branch" },
               { "diff",  source = require("gitsigns").diff_source },
            },
            lualine_c = {
               {
                  "filename",
                  path = 1,
                  newfile_status = false,
               },
            },
            lualine_x = {
               { "diagnostics", sources = { "nvim_diagnostic" } },
            },
            lualine_y = {
               { "progress", color = { gui = "bold" } },
            },
            lualine_z = {
               { "location", color = { gui = "bold" } },
            },
         },
         inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
         },
      })
   end,
}
