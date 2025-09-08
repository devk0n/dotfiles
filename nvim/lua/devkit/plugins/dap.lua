return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" }, -- 👈 required now
      },
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      
      dap.listeners.before.event_terminated["notify"] = function(session, body)
        vim.notify("🔴 Debug session terminated", vim.log.levels.WARN)
      end

      dap.listeners.before.event_exited["notify"] = function(session, body)
        local code = body.exitCode and (" with code " .. body.exitCode) or ""
        vim.notify("⚠️ Program exited" .. code, vim.log.levels.INFO)
      end

      -- GDB setup example
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = "/usr/bin/gdb", -- or lldb-vscode / codelldb
        args = { "--interpreter=dap" },
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = true,
          setupCommands = {
            {
              description = "Enable pretty-printing for gdb",
              text = "-enable-pretty-printing",
              ignoreFailures = true,
            },
          },
        },
      }
      dap.configurations.c = dap.configurations.cpp
      
      -- F-keys (like CLion)
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })

      -- Breakpoints
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>B", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: Conditional Breakpoint" })

      -- REPL & UI
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run Last" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })

      -- Eval (hover variable under cursor)
      vim.keymap.set({ "n", "v" }, "<leader>de", dapui.eval, { desc = "Debug: Evaluate Expression" })
    end,
  },
}
