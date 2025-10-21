return {
   "nvim-lualine/lualine.nvim",
   event = "VeryLazy", -- load after UI is ready (and after colorscheme)
   dependencies = {
      "nvim-tree/nvim-web-devicons",
      "lewis6991/gitsigns.nvim",
   },

   config = function()
      require("gitsigns").setup()

      local function reload_lualine()
         local theme_builder = require("devkit.config.dap.lualine_dap")
         require("lualine").setup({
            options = {
               theme = theme_builder(),
               globalstatus = true,
               section_separators = { left = "", right = "" },
               component_separators = { left = "|", right = "|" },
            },
            sections = {
               lualine_a = { {
                  "mode",
                  fmt = function(s)
                     if _G.DebugKeymapsActive then
                        return " DEBUG"
                     end
                     return " " .. s
                  end
               } },
               lualine_b = { "branch", { "diff", source = require("gitsigns").diff_source } },
               lualine_c = { "filename" },
               lualine_x = {
                  { "diagnostics", sources = { "nvim_diagnostic" } },
                  "encoding", "filetype",
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
      end

      -- initial setup
      reload_lualine()

      -- make it globally callable if you want
      _G.ReloadLualine = reload_lualine
   end
}
