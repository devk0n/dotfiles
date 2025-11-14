return {
   "lukas-reineke/indent-blankline.nvim",
   main = "ibl",
   opts = {
      whitespace = {
         remove_blankline_trail = true, -- don't draw indent guides on blank lines
      },
      scope = {
         enabled = true,     -- keep highlighting the current scope
         show_start = false, -- ❌ disables the top horizontal line
         show_end = false,   -- keep this off too for clean look
      },
   },
}
