
return {
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "clangd", "cmake" }, -- auto-install servers
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Common on_attach for keymaps
      local on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        local keymap = vim.keymap.set

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

        -- Formatting (if supported)
        keymap("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
      end

      -- Diagnostic signs
      local signs = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN]  = " ",
        [vim.diagnostic.severity.HINT]  = "󰠠 ",
        [vim.diagnostic.severity.INFO]  = " ",
      }
      vim.diagnostic.config({
        signs = { text = signs },
        virtual_text = true,
        underline = true,
        update_in_insert = false,
      })

      -- C/C++
      lspconfig.clangd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "clangd", "--background-index", "--clang-tidy" },
      })

      -- CMake
      lspconfig.cmake.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end,
  },
}
