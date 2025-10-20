-- ~/.config/nvim/lua/devkit/config/dap/init.lua
local dap = require("dap")

require("devkit.config.dap.adapters")(dap)
require("devkit.config.dap.configurations")(dap)
require("devkit.config.dap.signs")()
require("devkit.config.dap.keymaps")(dap)
require("devkit.config.dap.ui")(dap)

_G.DebugModeActive = false
_G.DebugKeymapsActive = false

-- keymap setup/teardown
local function set_debug_keymaps()
   if _G.DebugKeymapsActive then return end
   _G.DebugKeymapsActive = true

   local map = vim.keymap.set
   local opts = { silent = true, noremap = true }

   map("n", "<F5>", dap.continue, vim.tbl_extend("force", opts, { desc = "[DAP] Continue" }))
   map("n", "<F9>", dap.toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "[DAP] Toggle Breakpoint" }))
   map("n", "<F10>", dap.step_over, vim.tbl_extend("force", opts, { desc = "[DAP] Step Over" }))
   map("n", "<F11>", dap.step_into, vim.tbl_extend("force", opts, { desc = "[DAP] Step Into" }))
   map("n", "<S-F11>", dap.step_out, vim.tbl_extend("force", opts, { desc = "[DAP] Step Out" }))
   map("n", "<Leader>dr", dap.repl.open, vim.tbl_extend("force", opts, { desc = "[DAP] REPL" }))
end

local function clear_debug_keymaps()
   if not _G.DebugKeymapsActive then return end
   _G.DebugKeymapsActive = false

   pcall(vim.keymap.del, "n", "<F5>")
   pcall(vim.keymap.del, "n", "<F9>")
   pcall(vim.keymap.del, "n", "<F10>")
   pcall(vim.keymap.del, "n", "<F11>")
   pcall(vim.keymap.del, "n", "<S-F11>")
   pcall(vim.keymap.del, "n", "<Leader>dr")
end

-- toggle function
function _G.toggle_debug_keymaps()
   if _G.DebugKeymapsActive then
      clear_debug_keymaps()
      vim.notify("Debug keymaps disabled", vim.log.levels.INFO)
   else
      set_debug_keymaps()
      vim.notify("Debug keymaps enabled", vim.log.levels.INFO)
   end
end

-- DAP lifecycle hooks
dap.listeners.after.event_initialized["debug_flags"] = function()
   _G.DebugModeActive = true
   set_debug_keymaps() -- auto-enable on session start
end
dap.listeners.before.event_terminated["debug_flags"] = function()
   _G.DebugModeActive = false
   clear_debug_keymaps()
end
dap.listeners.before.event_exited["debug_flags"] = function()
   _G.DebugModeActive = false
   clear_debug_keymaps()
end

-- toggle binding
vim.keymap.set("n", "<Leader>dk", _G.toggle_debug_keymaps, { desc = "Toggle DAP keymaps" })
