return {
   "windwp/nvim-autopairs",
   event = "InsertEnter",
   dependencies = {
      "hrsh7th/nvim-cmp",
   },
   config = function()
      local autopairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")

      autopairs.setup({
         check_ts = true,                                     -- use treesitter
         ts_config = {
            lua = { "string" },                               -- don’t add pairs in Lua strings
            javascript = { "template_string" },
            java = false,                                     -- disable in Java
         },
         disable_filetype = { "TelescopePrompt", "vim", "oil" }, -- don’t interfere
         fast_wrap = {
            map = '<M-e>',
            chars = { '{', '[', '(', '"', "'" },
            pattern = [=[[%'%"%>%]%)%}%,]]=],
            end_key = '$',
            before_key = 'h',
            after_key = 'l',
            cursor_pos_before = true,
            keys = 'qwertyuiopzxcvbnmasdfghjkl',
            manual_position = true,
            highlight = 'Search',
            highlight_grey = 'Comment'
         },
      })

      -- Integration with nvim-cmp
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({
         map_char = {
            tex = "", -- don’t auto add `(` in LaTeX
         },
      }))
   end,
}
