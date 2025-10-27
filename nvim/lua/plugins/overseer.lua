return {
   dir = "/home/devkon/projects/overseer.nvim",
   config = function()
      local overseer = require("overseer")
      overseer.setup()

      local function register_task(name, script, display)
         overseer.register_template({
            name = name,
            builder = function()
               return {
                  cmd = { script },
                  cwd = os.getenv("CMAKE_SOURCE_DIR"),
                  name = display or name,
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

      -- Register tasks with short display names
      register_task("Initialize CMake project", "/home/devkon/projects/BuildTools/scripts/init", "init")
      register_task("Build with Bear + CMake", "/home/devkon/projects/BuildTools/scripts/build", "build")
      register_task("Rebuild with Bear + CMake", "/home/devkon/projects/BuildTools/scripts/rebuild", "rebuild")
      register_task("Clean CMake project", "/home/devkon/projects/BuildTools/scripts/clean", "clean")
      register_task("Run CMake project", "/home/devkon/projects/BuildTools/scripts/run", "run")

      -- Helper to run task and restart LSP on success
      local function run_with_lsp_restart(task_name)
         overseer.run_template({ name = task_name }, function(task)
            if task then
               -- open when running, but don’t steal cursor
               overseer.open({ enter = false })
               task:subscribe("on_complete", function(_, status)
                  if status == "SUCCESS" then
                     vim.schedule(function()
                        overseer.close()
                        pcall(vim.cmd, "LspRestart")
                     end)
                  else
                     -- keep Overseer window visible if failed
                     overseer.open({ enter = false })
                  end
               end)
            end
         end)
      end

      -- Commands
      vim.api.nvim_create_user_command("Build", function()
         run_with_lsp_restart("Build with Bear + CMake")
      end, {})

      vim.api.nvim_create_user_command("Init", function()
         run_with_lsp_restart("Initialize CMake project")
      end, {})

      vim.api.nvim_create_user_command("Rebuild", function()
         run_with_lsp_restart("Rebuild with Bear + CMake")
      end, {})

      vim.api.nvim_create_user_command("Clean", function()
         run_with_lsp_restart("Clean CMake project")
      end, {})

      vim.api.nvim_create_user_command("Run", function()
         overseer.run_template({ name = "Run CMake project" }, function(task)
            if task then
               overseer.open({ enter = false })
            end
         end)
      end, {})

      -- Optional: lowercase aliases
      vim.cmd("cnoreabbrev build Build")
      vim.cmd("cnoreabbrev init Init")
      vim.cmd("cnoreabbrev rebuild Rebuild")
      vim.cmd("cnoreabbrev clean Clean")
      vim.cmd("cnoreabbrev run Run")
   end,
}
