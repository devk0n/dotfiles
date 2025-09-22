-- Diagnostic config (icons, virtual text, floating, etc.)
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = "󰠠 ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
    },
  },
  virtual_text = {
    prefix = "●", -- or "" if you only want signs
  },
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
})

-- Diagnostic config (floating windows, virtual text, etc.)
vim.diagnostic.config({
  virtual_text = {
    prefix = "●", -- set "" if you want only signs
  },
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
})

-- Capabilities (completion, snippets, etc.)
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Helper: find project root
local function get_root(patterns)
  return vim.fs.dirname(
    vim.fs.find(patterns or { ".git" }, { upward = true })[1]
  )
end

-- Helper: register a server on specific filetypes
local function lsp_autocmd(filetypes, opts)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function()
      vim.lsp.start(vim.tbl_extend("force", {
        root_dir = get_root(opts.root_patterns),
        capabilities = capabilities,
      }, opts))
    end,
  })
end

-- User command: LspRestart
vim.api.nvim_create_user_command("LspRestart", function(opts)
  local clients = vim.lsp.get_clients()
  local target = opts.args ~= "" and opts.args or "all"

  if target == "all" then
    for _, client in pairs(clients) do
      vim.lsp.stop_client(client.id, true)
    end
    vim.cmd("edit") -- reload buffer to trigger autocmd -> lsp_autocmd
    print("Restarted all LSP clients")
  else
    for _, client in pairs(clients) do
      if client.name == target then
        vim.lsp.stop_client(client.id, true)
        vim.cmd("edit")
        print("Restarted LSP: " .. target)
        return
      end
    end
    print("No active LSP client named " .. target)
  end
end, {
  nargs = "?",
  complete = function()
    return vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients())
  end,
})

-- Language servers

-- C / C++
lsp_autocmd({ "c", "cpp", "objc", "objcpp" }, {
  name = "clangd",
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  root_patterns = { ".git", "compile_commands.json" },
})

-- CMake
lsp_autocmd({ "cmake" }, {
  name = "cmake",
  cmd = { "cmake-language-server" },
  root_patterns = { ".git", "CMakeLists.txt" },
})

-- Lua
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

-- Python
lsp_autocmd({ "python" }, {
  name = "pyright",
  cmd = { "pyright-langserver", "--stdio" },
  root_patterns = { ".git", "pyproject.toml", "setup.py", "requirements.txt" },
})

-- Go
lsp_autocmd({ "go", "gomod", "gowork", "gotmpl" }, {
  name = "gopls",
  cmd = { "gopls" },
  root_patterns = { ".git", "go.work", "go.mod" },
})

-- Rust
lsp_autocmd({ "rust" }, {
  name = "rust_analyzer",
  cmd = { "rust-analyzer" },
  root_patterns = { ".git", "Cargo.toml" },
})

-- JSON / YAML
lsp_autocmd({ "json" }, {
  name = "jsonls",
  cmd = { "vscode-json-language-server", "--stdio" },
  root_patterns = { ".git" },
})
lsp_autocmd({ "yaml" }, {
  name = "yamlls",
  cmd = { "yaml-language-server", "--stdio" },
  root_patterns = { ".git" },
})

-- Bash / sh
lsp_autocmd({ "sh" }, {
  name = "bashls",
  cmd = { "bash-language-server", "start" },
  root_patterns = { ".git" },
})

-- Keymaps (global for all LSPs)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, silent = true }

    -- Navigation / info
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    -- Refactor / actions
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    -- Diagnostics
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

    -- Formatting (manual trigger)
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})
