-- Diagnostics (icons + float border)
vim.diagnostic.config({
   signs = {
      text = {
         [vim.diagnostic.severity.ERROR] = " ",
         [vim.diagnostic.severity.WARN]  = " ",
         [vim.diagnostic.severity.HINT]  = "󰠠 ",
         [vim.diagnostic.severity.INFO]  = " ",
      },
   },
   virtual_text = {
      prefix = "●",
      spacing = 2,
   },
   float = {
      border = "rounded",
      source = "always",
      focusable = true,
   },
   severity_sort = true,
})

-- Remove backgrounds from diagnostic floats + virtual text
local function clear_diag_backgrounds()
   local groups = {
      "NormalFloat", "FloatBorder",
      "DiagnosticFloatingError", "DiagnosticFloatingWarn",
      "DiagnosticFloatingInfo", "DiagnosticFloatingHint",
      "DiagnosticVirtualTextError", "DiagnosticVirtualTextWarn",
      "DiagnosticVirtualTextInfo", "DiagnosticVirtualTextHint",
   }
   for _, g in ipairs(groups) do
      local hl = vim.api.nvim_get_hl(0, { name = g })
      -- keep fg/sp if they exist, just nuke bg
      vim.api.nvim_set_hl(0, g, vim.tbl_extend("force", hl, { bg = "NONE" }))
   end
end

clear_diag_backgrounds()
vim.api.nvim_create_autocmd("ColorScheme", {
   callback = clear_diag_backgrounds,
})

local function straight_diag_underlines_with_colors()
   local pairs = {
      { ul = "DiagnosticUnderlineError",           base = "DiagnosticError" },
      { ul = "DiagnosticUnderlineWarn",            base = "DiagnosticWarn" },
      { ul = "DiagnosticUnderlineInfo",            base = "DiagnosticInfo" },
      { ul = "DiagnosticUnderlineHint",            base = "DiagnosticHint" },
      -- legacy names some themes still link to:
      { ul = "LspDiagnosticsUnderlineError",       base = "DiagnosticError" },
      { ul = "LspDiagnosticsUnderlineWarning",     base = "DiagnosticWarn" },
      { ul = "LspDiagnosticsUnderlineInformation", base = "DiagnosticInfo" },
      { ul = "LspDiagnosticsUnderlineHint",        base = "DiagnosticHint" },
   }

   for _, p in ipairs(pairs) do
      local base = vim.api.nvim_get_hl(0, { name = p.base, link = true })
      local sp   = base.sp or base.fg -- prefer explicit special color; fall back to fg
      vim.api.nvim_set_hl(0, p.ul, { undercurl = false, underline = true, sp = sp })
   end
end

straight_diag_underlines_with_colors()
vim.api.nvim_create_autocmd("ColorScheme", {
   callback = straight_diag_underlines_with_colors,
})

-- Helper: find project root
local function get_root(patterns)
   return vim.fs.dirname(vim.fs.find(patterns or { ".git" }, { upward = true })[1])
end

-- Helper: autostart server for filetypes
local function lsp_autocmd(filetypes, opts)
   vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function()
         vim.lsp.start(vim.tbl_extend("force", {
            root_dir = get_root(opts.root_patterns),
         }, opts))
      end,
   })
end

-- Servers
lsp_autocmd({ "c", "cpp" }, {
   name = "clangd",
   cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
   },
   root_patterns = { ".git", "compile_commands.json" },
})

lsp_autocmd({ "lua" }, {
   name = "lua_ls",
   cmd = { "lua-language-server" },
   root_patterns = { ".git" },
   settings = {
      Lua = {
         diagnostics = { globals = { "vim" } },
         workspace = { checkThirdParty = false },
      },
   },
})

-- Keymaps (and disable LSP highlighting)
vim.api.nvim_create_autocmd("LspAttach", {
   callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
         -- kill semantic highlighting
         client.server_capabilities.semanticTokensProvider = nil
      end

      local opts = { buffer = args.buf, silent = true }
      local map = vim.keymap.set

      map("n", "gd", vim.lsp.buf.definition, opts)
      map("n", "gr", vim.lsp.buf.references, opts)
      map("n", "K", vim.lsp.buf.hover, opts)

      map("n", "<leader>ca", vim.lsp.buf.code_action, opts)

      map("n", "[d", vim.diagnostic.goto_prev, opts)
      map("n", "]d", vim.diagnostic.goto_next, opts)

      map("n", "<leader>k", function() vim.diagnostic.open_float(nil, { focus = false }) end, opts)

      map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, opts)
   end,
})

vim.api.nvim_create_user_command("LspRestart", function()
   vim.lsp.stop_client(vim.lsp.get_clients())
   vim.cmd("edit") -- reopen buffer to trigger LspAttach
end, {})
