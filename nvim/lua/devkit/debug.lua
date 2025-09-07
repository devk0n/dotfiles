local M = {}

function M.setup()
  local dap = require("dap")
  local dapui = require("dapui")

  ---------------------------------------------------------------------------
  -- Inline variables
  ---------------------------------------------------------------------------
  require("nvim-dap-virtual-text").setup({
    virt_text_pos = "eol",
    highlight_changed_variables = true,
    commented = false,
  })

  ---------------------------------------------------------------------------
  -- dap-ui (slim, single panels)
  ---------------------------------------------------------------------------
  dapui.setup({
    layouts = {
      { elements = { { id = "scopes", size = 1.0 } }, size = 40, position = "left" },
      { elements = { { id = "repl",   size = 1.0 } }, size = 12, position = "bottom" },
      { elements = { { id = "console",size = 1.0 } }, size = 10, position = "bottom" },
    },
    floating = { border = "rounded" },
    controls = { enabled = false },
  })

  dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
  dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end

  ---------------------------------------------------------------------------
  -- Signs
  ---------------------------------------------------------------------------
  vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
  vim.fn.sign_define("DapStopped", { text = "➤", texthl = "DiagnosticWarn", linehl = "Visual" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticHint" })

  ---------------------------------------------------------------------------
  -- Debugger adapter (lldb-dap → lldb-vscode → codelldb)
  ---------------------------------------------------------------------------
  local lldb_cmd = nil
  if vim.fn.executable("lldb-dap") == 1 then
    lldb_cmd = "lldb-dap"
  elseif vim.fn.executable("lldb-vscode") == 1 then
    lldb_cmd = "lldb-vscode"
  elseif vim.fn.executable(vim.fn.stdpath("data") .. "/mason/bin/codelldb") == 1 then
    lldb_cmd = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
  end

  if lldb_cmd then
    dap.adapters.lldb = {
      type = "executable",
      command = lldb_cmd,
      name = "lldb",
    }
  else
    vim.notify("⚠ No debugger found: install lldb (with dap) or codelldb", vim.log.levels.ERROR)
  end

  ---------------------------------------------------------------------------
  -- Configurations (C & C++)
  ---------------------------------------------------------------------------
  local function project_root()
    local cwd = vim.fn.getcwd(0)
    while cwd ~= "/" and vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 0 do
      cwd = vim.fn.fnamemodify(cwd, ":h")
    end
    return cwd
  end

  local function pick_program()
    local root = project_root()
    local default = root .. "/build/clang-debug/"
    return vim.fn.input("Path to executable: ", default, "file")
  end

  dap.configurations.cpp = {
    {
      name = "Launch C++",
      type = "lldb",
      request = "launch",
      program = pick_program,
      cwd = project_root,
      stopOnEntry = false,
      args = {},
      env = {},
      externalConsole = false,
      stopOnError = true,
    },
  }
  dap.configurations.c = dap.configurations.cpp

  ---------------------------------------------------------------------------
  -- Keymaps
  ---------------------------------------------------------------------------
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }

  -- Core
  map("n", "<leader>db", function() dap.toggle_breakpoint() end, opts)
  map("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, opts)
  map("n", "<leader>dc", function() dap.continue() end, opts)
  map("n", "<leader>dn", function() dap.step_over() end, opts)
  map("n", "<leader>di", function() dap.step_into() end, opts)
  map("n", "<leader>do", function() dap.step_out() end, opts)
  map("n", "<leader>dq", function() dap.terminate() end, opts)

  -- UI panels
  map("n", "<leader>ds", function() dapui.toggle(1) end, opts) -- Scopes
  map("n", "<leader>dr", function() dapui.toggle(2) end, opts) -- REPL
  map("n", "<leader>dO", function() dapui.toggle(3) end, opts) -- Console

  -- Hover & preview
  map("n", "K", function() require("dap.ui.widgets").hover() end, { desc = "DAP Hover" })
  map({ "n", "v" }, "<leader>de", function() require("dap.ui.widgets").preview() end, { desc = "DAP Preview/Eval" })
end

return M
