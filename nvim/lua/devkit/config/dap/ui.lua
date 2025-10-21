return function(dap)
   local dapui = require("dapui")

   dapui.setup({
      layouts = {
         {
            elements = {
               { id = "scopes",      size = 0.4 },
               { id = "watches",     size = 0.2 },
               { id = "stacks",      size = 0.2 },
               { id = "breakpoints", size = 0.2 },
            },
            size = 50,
            position = "right",
         },
      },
   })

   dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
      _G.DebugModeActive = true
      require("devkit.utils.lualine").reload()
   end
   dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
   end
   dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
   end
end
