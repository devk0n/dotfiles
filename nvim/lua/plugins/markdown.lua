return {
   "iamcco/markdown-preview.nvim",
   ft = { "markdown", "md" },

   build = function()
      vim.fn["mkdp#util#install"]()
   end,

   config = function()
      vim.g.mkdp_browserfunc = "MarkdownPreviewFirefox"
      vim.g.mkdp_auto_start = 1
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_combine_preview = 1
      vim.g.mkdp_combine_preview_auto_refresh = 1
      vim.g.mkdp_theme = "dark"

      local firefox_profile = vim.fn.expand("~/.mozilla/firefox/adyyomzx.markdown/")

      vim.api.nvim_exec2([[
         function! MarkdownPreviewFirefox(url)
           execute 'lua OpenMarkdownPreview("' . a:url . '")'
         endfunction
      ]], {})

      function _G.OpenMarkdownPreview(url)
         vim.fn.jobstart({
            "firefox",
            "--no-remote",
            "--new-instance",
            "--profile", firefox_profile,
            "--new-window",
            url,
         })
      end

      -- Keymap only for markdown buffers
      vim.api.nvim_create_autocmd("FileType", {
         pattern = "markdown",
         callback = function()
            vim.keymap.set("n", "<leader>md", "<cmd>MarkdownPreview<CR>", { buffer = true, silent = true })
         end,
      })
   end,
}
