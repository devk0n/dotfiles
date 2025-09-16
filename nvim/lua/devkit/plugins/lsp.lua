return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Common keymaps
      local on_attach = function(_, bufnr)
        local keymap = vim.keymap.set
        local opts = { noremap = true, silent = true, buffer = bufnr }

        -- Navigation
        keymap("n", "gd", vim.lsp.buf.definition, opts)
        keymap("n", "gD", vim.lsp.buf.declaration, opts)
        keymap("n", "gi", vim.lsp.buf.implementation, opts)
        keymap("n", "gr", vim.lsp.buf.references, opts)
        keymap("n", "K", vim.lsp.buf.hover, opts)
        keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts)

        -- Workspace / diagnostics
        keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
        keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        keymap("n", "<leader>e", vim.diagnostic.open_float, opts)
        keymap("n", "[d", vim.diagnostic.goto_prev, opts)
        keymap("n", "]d", vim.diagnostic.goto_next, opts)
        keymap("n", "<leader>q", vim.diagnostic.setloclist, opts)

        -- Formatting
        keymap("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
        keymap("n", "<leader>af", function()
          vim.lsp.buf.code_action({
            apply = true,
          })
        end, opts)
      end

      -- Diagnostic signs
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.HINT]  = "󰠠",
            [vim.diagnostic.severity.INFO]  = "",
          },
        },
        virtual_text = true,
        underline = true,
        update_in_insert = false,
      })

      -- === LSP servers ===

      -- C / C++
      lspconfig.clangd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu", -- suggest headers (include-what-you-use)
          "--header-insertion-decorators",
        },
      })

      -- CMake
      lspconfig.cmake.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Lua (for Neovim configs)
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      -- Bash
      lspconfig.bashls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end,
  },
}
