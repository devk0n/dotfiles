return {
   "nvim-lualine/lualine.nvim",
   event = "VeryLazy", -- load after UI is ready (and after colorscheme)
   dependencies = {
      "nvim-tree/nvim-web-devicons",
      "lewis6991/gitsigns.nvim",
   },
   config = function()
      require("gitsigns").setup()

      local colors = require("catppuccin.palettes").get_palette("mocha")

      require("lualine").setup({
         options = {
            theme = "auto", -- auto picks up catppuccin
            globalstatus = true,
            always_divide_middle = false,
            section_separators = { left = "", right = "" },
            component_separators = { left = "|", right = "|" },
         },
         sections = {
            lualine_a = {
               {
                  function()
                     local mode_map = {
                        n = "NORMAL",
                        i = "INSERT",
                        v = "VISUAL",
                        V = "V-LINE",
                        R = "REPLACE",
                        c = "COMMAND",
                     }
                     local mode = mode_map[vim.api.nvim_get_mode().mode] or vim.api.nvim_get_mode().mode

                     if _G.DebugModeActive and _G.DebugKeymapsActive then
                        return "DEBUG"
                     elseif _G.DebugModeActive and not _G.DebugKeymapsActive then
                        return "DEBUG (" .. mode .. ")"
                     elseif _G.DebugKeymapsActive then
                        return mode
                     else
                        return " " .. mode
                     end
                  end,
                  color = function()
                     if _G.DebugModeActive then
                        return { fg = colors.red, gui = "bold" }
                     end
                  end,
               },
            },
            lualine_b = {
               "branch",
               { "diff", source = require("gitsigns").diff_source },
            },
            lualine_c = { "filename" },
            lualine_x = {
               { "diagnostics", sources = { "nvim_diagnostic" } }, -- use new diagnostics source
               "encoding",
               "filetype",
            },
            lualine_y = { "progress" },
            lualine_z = { "location" },
         },
         inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
         },
      })
   end,
}
