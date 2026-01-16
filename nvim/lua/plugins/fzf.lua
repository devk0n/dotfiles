return {
   "ibhagwan/fzf-lua",
   dependencies = { "nvim-tree/nvim-web-devicons" },
   keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>",     desc = "Find files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
   },
   config = function()
      local fzf = require("fzf-lua")

      fzf.setup({
         winopts = {
            height  = 0.85,
            width   = 0.80,
            preview = {
               default = "builtin",
               extensions = {
                  [""]    = "builtin",
                  ["lua"] = { "bat", "--style=plain", "--color=always" },
                  ["c"]   = { "bat", "--style=plain", "--color=always" },
                  ["cpp"] = { "bat", "--style=plain", "--color=always" },
                  ["h"]   = { "bat", "--style=plain", "--color=always" },
                  ["md"]  = { "bat", "--style=plain", "--color=always" },
               },
            },
         },

         -------------------------------------------------------------------
         -- FILE SEARCH
         -------------------------------------------------------------------
         files = {
            cmd = table.concat({
               "fd --type f --hidden",
               "--exclude .git",
               "--exclude external",
               "--exclude build",
               "--exclude assets",
               "--exclude out",
               "--exclude third_party",
               "--exclude node_modules",
               "--exclude compile_commands.json"
            }, " "),
            actions = {
               ["default"] = fzf.actions.file_edit,
               ["ctrl-s"]  = fzf.actions.file_split,
               ["ctrl-v"]  = fzf.actions.file_vsplit,
               ["ctrl-t"]  = fzf.actions.file_tabedit,
               ["ctrl-q"]  = fzf.actions.file_quickfix,
            },
         },

         -------------------------------------------------------------------
         -- GREP SEARCH
         -------------------------------------------------------------------
         grep = {
            rg_opts = table.concat({
               "--hidden",
               "--column",
               "--line-number",
               "--no-heading",
               "--color=always",
               "--smart-case",
               "--glob '!*.git'",
               "--glob '!external/*'",
               "--glob '!build/*'",
               "--glob '!assets/*'",
               "--glob '!out/*'",
               "--glob '!third_party/*'",
               "--glob '!node_modules/*'",
               "--glob '!compile_commands.json'"
            }, " "),
            actions = {
               ["default"] = fzf.actions.grep_edit,
            },
         },
      })
   end,
}
