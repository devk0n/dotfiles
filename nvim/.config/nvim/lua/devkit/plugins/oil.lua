return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional, for icons

  -- Disable netrw early so Oil can take over as the file explorer
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,

  -- Setup
  config = function()
    require("oil").setup({
      default_file_explorer = true,    -- replace netrw with Oil
      delete_to_trash = true,          -- requires `trash-cli` on Linux
      skip_confirm_for_simple_edits = true,
      watch_for_changes = true,

      -- Show/hide columns (leave empty for minimal UI)
      -- Common choices: "icon", "permissions", "size", "mtime"
      columns = {
        "icon",
      },

      -- Oil-specific keymaps (only inside Oil buffers)
      keymaps = {
        ["<C-h>]"] = false,            -- example: disable built-in if you don’t want it
        ["<C-c>"] = false,             -- don’t close Oil on <C-c>
        ["<M-h>"] = "actions.select_split",
        ["q"] = "actions.close",
      },

      view_options = {
        show_hidden = true,            -- show dotfiles
      },
    })

    -- Global mappings
    vim.keymap.set("n", "<leader>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    vim.keymap.set("n", "-", require("oil").toggle_float, { desc = "Oil (float)" })

    -- Buffer-local tweaks in Oil
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        vim.opt_local.cursorline = true
      end,
      desc = "Oil: enable cursorline",
    })

    -- Auto-change Neovim’s working directory to match Oil
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "oil://*",
      callback = function()
        local dir = require("oil").get_current_dir()
        if dir then
          vim.cmd.cd(dir)   -- change cwd
        end
      end,
      desc = "Oil: follow current directory",
    })
  end,
}
