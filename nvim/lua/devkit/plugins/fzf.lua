-- helper: get git root or fallback to cwd
local function project_root()
  local fzf = require("fzf-lua")
  local ok, root = pcall(function()
    return fzf.path.git_root({})
  end)
  if ok and root and #root > 0 then
    return root
  end
  return vim.loop.cwd()
end

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
          cwd = project_root,
        },
        winopts = { preview = { default = "bat_native" } },
      }
    end,
    keys = function()
      local fzf = require("fzf-lua")
      return {
        {
          "<leader>pf",
          function() fzf.files({ cwd = project_root() }) end,
          desc = "Find Files (project root)",
        },
        {
          "<leader>pc",
          function() fzf.files({ cwd = vim.fn.expand("~/.config/nvim/lua") }) end,
          desc = "Find Config",
        },
        {
          "<leader>ps",
          function() fzf.live_grep({ cwd = project_root() }) end,
          desc = "Grep (project root)",
        },
        {
          "<leader>pws",
          function()
            local mode = vim.fn.mode()
            if mode == "v" or mode == "V" then
              fzf.grep_visual({ cwd = project_root() })
            else
              fzf.grep_cword({ cwd = project_root() })
            end
          end,
          mode = { "n", "x" },
          desc = "Grep Word/Visual (project root)",
        },
        { "<leader>pk", function() fzf.keymaps() end, desc = "Search Keymaps" },
      }
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>",                  desc = "Lazygit" },
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
