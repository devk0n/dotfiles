return {
   "mfussenegger/nvim-dap",
   dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
   },
   config = function()
      require("devkit.config.dap") -- loads lua/config/dap/init.lua
   end,
}
