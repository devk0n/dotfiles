local dap = require("dap")

require("devkit.config.dap.adapters")(dap)
require("devkit.config.dap.configurations")(dap)
require("devkit.config.dap.signs")()
require("devkit.config.dap.keymaps")(dap)
require("devkit.config.dap.ui")(dap)

_G.DebugModeActive = false
_G.DebugKeymapsActive = false
