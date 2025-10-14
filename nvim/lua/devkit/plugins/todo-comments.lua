return {
   "folke/todo-comments.nvim",
   dependencies = { "nvim-lua/plenary.nvim" },
   opts = function()
      local palette = require("catppuccin.palettes").get_palette("macchiato")

      return {
         signs = true,
         sign_priority = 8,
         keywords = {
            FIX = {
               icon = " ", -- bug
               color = "fix",
               alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
            },
            TODO = { icon = "󰸞 ", color = "todo" },
            HACK = { icon = "󱇎 ", color = "hack" },
            WARN = { icon = " ", color = "warn", alt = { "WARNING", "XXX" } },
            PERF = { icon = " ", color = "perf", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = "󰍨 ", color = "note", alt = { "INFO" } },
            TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
         },
         colors = {
            fix     = { palette.red },
            todo    = { palette.sky },
            hack    = { palette.peach },
            warn    = { palette.yellow },
            perf    = { palette.mauve },
            note    = { palette.teal },
            test    = { palette.pink },
            default = { palette.lavender },
         },
         gui_style = {
            fg = "BOLD",
            bg = "BOLD",
         },
         merge_keywords = true,
         highlight = {
            multiline = true,
            multiline_pattern = "^.",
            multiline_context = 10,
            before = "",
            keyword = "wide_bg",
            after = "fg",
            pattern = [[.*<(KEYWORDS)\s*:]],
            comments_only = true,
            max_line_len = 400,
            exclude = {},
         },
         search = {
            command = "rg",
            args = {
               "--color=never",
               "--no-heading",
               "--with-filename",
               "--line-number",
               "--column",
            },
            pattern = [[\b(KEYWORDS):]],
         },
      }
   end,
}
