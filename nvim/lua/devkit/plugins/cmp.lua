return {
   {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
         "hrsh7th/cmp-nvim-lsp",         -- LSP completions
         "hrsh7th/cmp-buffer",           -- buffer words
         "hrsh7th/cmp-path",             -- filesystem paths
         "L3MON4D3/LuaSnip",             -- snippet engine
         "saadparwaiz1/cmp_luasnip",     -- connect LuaSnip with cmp
         "rafamadriz/friendly-snippets", -- big collection of ready-made snippets
      },
      config = function()
         local cmp = require("cmp")
         local luasnip = require("luasnip")

         -- Load community snippets (from friendly-snippets)
         require("luasnip.loaders.from_vscode").lazy_load()

         cmp.setup({
            snippet = {
               expand = function(args)
                  luasnip.lsp_expand(args.body) -- use LuaSnip for snippet expansion
               end,
            },

            mapping = cmp.mapping.preset.insert({
               ["<C-b>"] = cmp.mapping.scroll_docs(-4),           -- scroll docs up
               ["<C-f>"] = cmp.mapping.scroll_docs(4),            -- scroll docs down
               ["<C-Space>"] = cmp.mapping.complete(),            -- trigger completion
               ["<C-e>"] = cmp.mapping.abort(),                   -- close menu
               ["<CR>"] = cmp.mapping.confirm({ select = true }), -- confirm selection

               -- Tab to jump through snippets or cmp menu
               ["<Tab>"] = function(fallback)
                  if cmp.visible() then
                     cmp.select_next_item()
                  elseif luasnip.expand_or_jumpable() then
                     luasnip.expand_or_jump()
                  else
                     fallback()
                  end
               end,
               ["<S-Tab>"] = function(fallback)
                  if cmp.visible() then
                     cmp.select_prev_item()
                  elseif luasnip.jumpable(-1) then
                     luasnip.jump(-1)
                  else
                     fallback()
                  end
               end,
            }),

            sources = cmp.config.sources({
               { name = "nvim_lsp" },
               { name = "luasnip" },
               { name = "path" },
            }, {
               { name = "buffer" },
            }),
         })
      end,
   },
}
