return function(dap)
   local map = vim.keymap.set
   local saved = {}

   -- forward declare so we can call it inside apply_debug_maps
   local restore_maps

   local function apply_debug_maps()
      local debug_maps = {
         { "n", "c",          dap.continue,                                                              "DAP continue / start" },
         { "n", "T",          dap.terminate,                                                             "DAP stop debugging" },
         { "n", "b",          dap.toggle_breakpoint,                                                     "DAP toggle breakpoint" },
         { "n", "B",          function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, "DAP conditional breakpoint" },
         { "n", "<C-F9>",     function() dap.set_breakpoint(nil, nil, nil, true) end,                    "DAP toggle breakpoint enabled" },
         { "n", "n",          dap.step_over,                                                             "DAP step over" },
         { "n", "i",          dap.step_into,                                                             "DAP step into" },
         { "n", "o",          dap.step_out,                                                              "DAP step out" },
         { "n", "<Leader>dr", dap.repl.open,                                                             "DAP open REPL" },
         { "n", "<Leader>dl", dap.run_last,                                                              "DAP run last" },

         -- Escape exits debug mode
         { "n", "<Esc>", function()
            restore_maps()
            _G.DebugKeymapsActive = false
            require("devkit.utils.lualine").reload()
            print("Debug keymaps OFF (via <Esc>)")
         end, "Exit debug keymaps" },
      }
      for _, m in ipairs(debug_maps) do
         local mode, lhs, rhs, desc = unpack(m)

         -- backup existing mapping (if any)
         local old = vim.fn.maparg(lhs, mode, false, true)
         if old and old.rhs ~= "" then
            saved[lhs] = old
         end

         map(mode, lhs, rhs, { desc = desc, noremap = true, silent = true })
      end
   end

   restore_maps = function()
      for lhs, old in pairs(saved) do
         if old and old.rhs and old.rhs ~= "" then
            -- restore previous mapping
            vim.keymap.set(old.mode or "n", lhs, old.rhs, {
               noremap = old.noremap == 1,
               silent  = old.silent == 1,
               expr    = old.expr == 1,
               desc    = old.desc,
            })
         else
            -- nothing was mapped before → clear it
            pcall(vim.keymap.del, old.mode or "n", lhs)
         end
      end
      saved = {}
   end

   -- hook into dap lifecycle
   dap.listeners.after.event_initialized["dap_keymaps"] = function()
      apply_debug_maps()
      _G.DebugKeymapsActive = true
   end
   dap.listeners.before.event_terminated["dap_keymaps"] = function()
      restore_maps()
      _G.DebugKeymapsActive = false
   end
   dap.listeners.before.event_exited["dap_keymaps"] = function()
      restore_maps()
      _G.DebugKeymapsActive = false
   end

   vim.api.nvim_create_user_command("ToggleDebugKeymaps", function()
      if _G.DebugKeymapsActive then
         restore_maps()
         _G.DebugKeymapsActive = false
         print("Debug keymaps OFF")
      else
         apply_debug_maps()
         _G.DebugKeymapsActive = true
         print("Debug keymaps ON")
      end
   end, {})
end
