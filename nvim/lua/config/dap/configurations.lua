return function(dap)
   local cmake_bin        = os.getenv("BUILD_DIR")
   local executable       = os.getenv("EXECUTABLE")

   dap.configurations.cpp = {
      {
         name = "Launch C++ program",
         type = "cppdbg",
         request = "launch",
         program = executable,
         cwd = cmake_bin or vim.fn.getcwd(),
         stopAtEntry = false,
         MIMode = "gdb",
      },
   }

   dap.configurations.c   = dap.configurations.cpp
end
