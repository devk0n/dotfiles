return {
   "stevearc/overseer.nvim",
   config = function()
      local overseer = require("overseer")
      overseer.setup()

      -- Helper to register a CMake-related script task
      local function register_task(name, script, short)
         overseer.register_template({
            name = name,
            builder = function()
               return {
                  cmd = { script },
                  cwd = vim.env.CMAKE_SOURCE_DIR,
                  name = short or name,
                  components = {
                     "default",
                     "on_exit_set_status",
                     "on_complete_notify",
                     "on_output_quickfix",
                  },
               }
            end,
         })
      end

      -- Register BuildTools tasks
      local BIN = "/home/devkon/projects/BuildTools/bin/"
      register_task("Initialize CMake project", BIN .. "init.sh", "init")
      register_task("Build with Bear + CMake", BIN .. "build.sh", "build")
      register_task("Rebuild with Bear + CMake", BIN .. "rebuild.sh", "rebuild")
      register_task("Clean CMake project", BIN .. "clean.sh", "clean")
      register_task("Run CMake project", BIN .. "run.sh", "run")

      -- Run a task and restart LSP on success
      local function run_with_lsp_restart(task_name)
         overseer.run_task({ name = task_name }, function(task)
            if not task then return end

            overseer.open({ enter = false })

            task:subscribe("on_complete", function(_, status)
               if status == "SUCCESS" then
                  vim.schedule(function()
                     overseer.close()
                     pcall(vim.cmd, "LspRestart")
                  end)
               else
                  overseer.open({ enter = false })
               end
            end)
         end)
      end

      -- Commands
      vim.api.nvim_create_user_command("Build", function() run_with_lsp_restart("Build with Bear + CMake") end, {})
      vim.api.nvim_create_user_command("Init", function() run_with_lsp_restart("Initialize CMake project") end, {})
      vim.api.nvim_create_user_command("Rebuild", function() run_with_lsp_restart("Rebuild with Bear + CMake") end, {})
      vim.api.nvim_create_user_command("Clean", function() run_with_lsp_restart("Clean CMake project") end, {})

      vim.api.nvim_create_user_command("Run", function()
         overseer.run_task({ name = "Run CMake project" }, function(task)
            if task then
               overseer.open({ enter = false })
            end
         end)
      end, {})

      -- Lowercase aliases
      vim.cmd([[
      cnoreabbrev build Build
      cnoreabbrev init Init
      cnoreabbrev rebuild Rebuild
      cnoreabbrev clean Clean
      cnoreabbrev run Run
    ]])
   end,
}
