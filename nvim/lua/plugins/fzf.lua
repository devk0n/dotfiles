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
               -- fallback: use builtin previewer if bat fails
               default = "builtin",
               -- try bat first, fallback to builtin
               extensions = {
                  [""]    = "builtin", -- directories (no extension) → builtin
                  ["lua"] = { "bat", "--style=plain", "--color=always" },
                  ["c"]   = { "bat", "--style=plain", "--color=always" },
                  ["cpp"] = { "bat", "--style=plain", "--color=always" },
                  ["h"]   = { "bat", "--style=plain", "--color=always" },
                  ["md"]  = { "bat", "--style=plain", "--color=always" },
                  -- add more as you like
               },
            },
         },
         files = {
            cmd = "fd --type f --hidden --exclude .git",
            actions = {
               ["default"] = fzf.actions.file_edit,
               ["ctrl-s"] = fzf.actions.file_split,
               ["ctrl-v"] = fzf.actions.file_vsplit,
               ["ctrl-t"] = fzf.actions.file_tabedit,
               ["ctrl-q"] = fzf.actions.file_quickfix,
            },
         },
         grep = {
            rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git'",
            actions = {
               ["default"] = fzf.actions.file_edit,
            },
         },
      })
   end,
}
