return {
   {
      "mfussenegger/nvim-dap",
      config = function()
         local dap = require("dap")

         local ok, json = pcall(function()
            local file = io.open("/tmp/build-meta/config.json", "r")
            if not file then return nil end
            local data = file:read("*a")
            file:close()
            return vim.fn.json_decode(data)
         end)

         local buildmeta = ok and json or {}
         local exe = buildmeta.EXECUTABLE_PATH
         local root = buildmeta.PROJECT_ROOT

         dap.adapters.cppdbg = {
            id = "cppdbg",
            type = "executable",
            command = "/home/devkon/.local/share/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
         }

         dap.configurations.cpp = {
            {
               name = "Launch C++ program",
               type = "cppdbg",
               request = "launch",
               program = exe,
               cwd = root,
               stopAtEntry = false,
               MIMode = "gdb",
            },
         }

         -- Reuse for C
         dap.configurations.c = dap.configurations.cpp

         -- Breakpoint: solid red circle
         vim.fn.sign_define("DapBreakpoint", {
            text = "", -- nicer circle (nf-md-record-circle-outline)
            texthl = "DiagnosticError",
            linehl = "",
            numhl = ""
         })

         -- Conditional Breakpoint: circle with question mark
         vim.fn.sign_define("DapBreakpointCondition", {
            text = "", -- nf-fa-question-circle
            texthl = "DiagnosticWarn",
            linehl = "",
            numhl = ""
         })

         -- Breakpoint Rejected: circle with cross
         vim.fn.sign_define("DapBreakpointRejected", {
            text = "", -- nf-oct-x
            texthl = "DiagnosticError",
            linehl = "",
            numhl = ""
         })

         -- Execution stopped: right arrow
         vim.fn.sign_define("DapStopped", {
            text = "", -- nf-fa-arrow-right
            texthl = "DiagnosticInfo",
            linehl = "Visual",
            numhl = ""
         })

         -- Log Point: info circle
         vim.fn.sign_define("DapLogPoint", {
            text = "", -- nf-fa-exclamation-circle
            texthl = "DiagnosticHint",
            linehl = "",
            numhl = ""
         })

         -- Keymaps
         vim.keymap.set("n", "<F5>", function() dap.continue() end)
         vim.keymap.set("n", "<F10>", function() dap.step_over() end)
         vim.keymap.set("n", "<F11>", function() dap.step_into() end)
         vim.keymap.set("n", "<F12>", function() dap.step_out() end)
         vim.keymap.set("n", "<Leader>b", function() dap.toggle_breakpoint() end)
         vim.keymap.set("n", "<Leader>B", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
         end)
      end,
   },
}
