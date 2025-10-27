local dap = require("dap")

require("config.dap.adapters")(dap)
require("config.dap.configurations")(dap)
require("config.dap.signs")()
require("config.dap.ui")(dap)
require("config.dap.keymaps")(dap)
