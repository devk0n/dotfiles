return {
   {
      "mfussenegger/nvim-dap",
      config = function()
         local dap = require("dap")

         -- cpptools adapter (OpenDebugAD7)
         dap.adapters.cppdbg = {
            id = "cppdbg",
            type = "executable",
            command = vim.fn.expand("~/.local/share/cpptools/extension/debugAdapters/bin/OpenDebugAD7"),
         }

         -- Config for C/C++ using arm-none-eabi-gdb and OpenOCD/JLink
         dap.configurations.cpp = {
            {
               name = "Debug on target (OpenOCD/JLink)",
               type = "cppdbg",   -- must match adapter id above
               request = "launch",
               program = function()
                  return vim.fn.input("Path to ELF: ", vim.fn.getcwd() .. "/build/", "file")
               end,
               cwd = "${workspaceFolder}",
               stopAtEntry = false,
               MIMode = "gdb",
               miDebuggerPath = "arm-none-eabi-gdb",
               miDebuggerServerAddress = "localhost:3333", -- OpenOCD/JLinkGDBServer
               setupCommands = {
                  { text = "target remote localhost:3333" },
                  { text = "monitor reset halt" },
                  { text = "load" },
               },
            },
         }

         -- Reuse for C
         dap.configurations.c = dap.configurations.cpp

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
