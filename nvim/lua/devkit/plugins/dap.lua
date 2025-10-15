return {
   {
      "mfussenegger/nvim-dap",
      config = function()
         local dap                                          = require("dap")

         dap.defaults.fallback.terminal_win_cmd             = '10split new'

         dap.listeners.after.event_output["dap_autoscroll"] = function(_, body)
            -- find the terminal buffer/window
            for _, win in ipairs(vim.api.nvim_list_wins()) do
               local buf = vim.api.nvim_win_get_buf(win)
               if vim.bo[buf].buftype == "terminal" then
                  local line_count = vim.api.nvim_buf_line_count(buf)
                  vim.api.nvim_win_set_cursor(win, { line_count, 0 })
               end
            end
         end

         local ok, json                                     = pcall(function()
            local file = io.open("/tmp/build-meta/config.json", "r")
            if not file then return nil end
            local data = file:read("*a")
            file:close()
            return vim.fn.json_decode(data)
         end)

         local buildmeta                                    = ok and json or {}
         local exe                                          = buildmeta.EXECUTABLE_PATH
         local root                                         = buildmeta.PROJECT_ROOT

         dap.adapters.cppdbg                                = {
            id = "cppdbg",
            type = "executable",
            command = "/home/devkon/.local/share/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
         }

         dap.configurations.cpp                             = {
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
         dap.configurations.c                               = dap.configurations.cpp

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

         -- Run control
         vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP continue / start" })  -- F5
         vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = "DAP stop debugging" }) -- Shift+F5

         -- Breakpoints
         vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" }) -- F9
         vim.keymap.set("n", "<S-F9>", function()                                               -- Shift+F9
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
         end, { desc = "DAP conditional breakpoint" })
         vim.keymap.set("n", "<C-F9>", function()   -- Ctrl+F9
            dap.set_breakpoint(nil, nil, nil, true) -- disable/enable (toggle) -- see note below
         end, { desc = "DAP disable/enable breakpoint" })

         -- Stepping
         vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP step over" }) -- F10
         vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP step into" }) -- F11
         vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = "DAP step out" }) -- Shift+F11

         -- Debug Console & Extras
         vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "DAP open REPL (debug console)" })
         vim.keymap.set("n", "<Leader>dl", dap.run_last, { desc = "DAP run last configuration" })
      end,
   },
}
