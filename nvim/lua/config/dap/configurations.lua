return function(dap)
   local cmake_bin        = os.getenv("CMAKE_BINARY_DIR")
   local project          = os.getenv("PROJECT_NAME")

   dap.configurations.cpp = {
      {
         name = "Launch C++ program",
         type = "cppdbg",
         request = "launch",
         program = (cmake_bin and project)
             and (cmake_bin .. "/" .. project),
         cwd = cmake_bin or vim.fn.getcwd(),
         stopAtEntry = false,
         MIMode = "gdb",
      },
   }

   dap.configurations.c   = dap.configurations.cpp
end
