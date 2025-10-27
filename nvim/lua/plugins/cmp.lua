return {
   {
      "saghen/blink.cmp",
      version = "1.*",
      opts = {
         keymap = {
            preset      = "none",
            ["<Tab>"]   = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<CR>"]    = { "accept", "fallback" },
         },
         sources = {
            default = {
               "lsp",
               "path",
               "buffer",
               "cmdline",
            },
         },
         fuzzy = { implementation = "rust" },
      },
   }
}
