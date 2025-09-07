return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local has_fd = vim.fn.executable("fd") == 1
      return {
        files = {
          cmd = has_fd and "fd --type f --hidden --follow --exclude .git" or nil,
        },
        grep = {
          cmd = "rg",
          rg_opts = "--hidden --follow --glob '!.git' --line-number --column --no-heading --smart-case",
          silent = true,
        },
        winopts = { preview = { default = "bat_native" } },
      }
    end,
    keys = {
      { "<leader>pf", function() require("fzf-lua").files() end, desc = "Find Files" },
      { "<leader>pc", function() require("fzf-lua").files({ cwd = vim.fn.expand("~/.config/nvim/lua") }) end, desc = "Find Config" },
      { "<leader>ps", function() require("fzf-lua").live_grep() end, desc = "Grep" },
      {
        "<leader>pws",
        function()
          local mode = vim.fn.mode()
          if mode == "v" or mode == "V" then
            require("fzf-lua").grep_visual()
          else
            require("fzf-lua").grep_cword()
          end
        end,
        mode = { "n", "x" },
        desc = "Grep Word/Visual"
      },
      { "<leader>pk", function() require("fzf-lua").keymaps() end, desc = "Search Keymaps" },
    },
  },

  {
    "kdheepak/lazygit.nvim",
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Lazygit" },
      { "<leader>gl", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "Lazygit Logs (file)" },
    },
  },

  {
    "echasnovski/mini.bufremove",
    keys = {
      { "<leader>dB", function() require("mini.bufremove").delete(0, true) end, desc = "Close Buffer (confirm)" },
    },
  },
}
