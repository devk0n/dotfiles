return function(dap)
   local map = vim.keymap.set

   -- Start/continue
   map("n", "<F5>", function() dap.continue() end)

   -- Step into/over/out
   map("n", "<F10>", function() dap.step_over() end)
   map("n", "<F11>", function() dap.step_into() end)
   map("n", "<F12>", function() dap.step_out() end)

   -- Toggle breakpoint
   map("n", "<F9>", function() dap.toggle_breakpoint() end)

   -- Set conditional breakpoint
   map("n", "<leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
   end)

   -- REPL
   map("n", "<leader>dr", function() dap.repl.toggle() end)

   -- Run last
   map("n", "<leader>dl", function() dap.run_last() end)
end
