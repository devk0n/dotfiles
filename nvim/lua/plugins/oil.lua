return {
   "stevearc/oil.nvim",
   dependencies = { "nvim-tree/nvim-web-devicons" },
   config = function()
      require("oil").setup({
         default_file_explorer = true,
         watch_for_changes = true,
         columns = {
            "icon"
         },
         view_options = {
            show_hidden = true,
         },
         skip_confirm_for_simple_edits = true,
      })

      -- Auto-change Neovim’s working directory to match Oil
      vim.api.nvim_create_autocmd("BufEnter", {
         pattern = "oil://*",
         callback = function()
            local dir = require("oil").get_current_dir()
            if dir then
               vim.cmd.cd(dir) -- change cwd
            end
         end,
         desc = "Oil: follow current directory",
      })

      vim.api.nvim_create_autocmd({ "BufEnter" }, {
         callback = function()
            local ft = vim.bo.filetype
            if ft == "markdown" then
               -- Only open preview if not already open
               vim.cmd("MarkdownPreview")
            end
         end,
      })
   end,

   vim.keymap.set("n", "-", "<CMD>Oil<CR>")
}
