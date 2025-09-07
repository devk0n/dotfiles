return {
  "3rd/image.nvim",
  build = false, -- no build step needed
  opts = {
    backend = "kitty", -- or "ueberzug"
    integrations = {
      markdown = {
        enabled = true,
        download_remote = true,
      },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = 50,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  },
}
