return function()
   local signs = {
      DapBreakpoint          = { "", "DiagnosticError" },
      DapBreakpointCondition = { "", "DiagnosticWarn" },
      DapBreakpointRejected  = { "", "DiagnosticError" },
      DapStopped             = { "", "DiagnosticInfo", "Visual" },
      DapLogPoint            = { "", "DiagnosticHint" },
   }

   for name, opts in pairs(signs) do
      vim.fn.sign_define(name, {
         text = opts[1],
         texthl = opts[2],
         linehl = opts[3] or "",
         numhl = "",
      })
   end
end
