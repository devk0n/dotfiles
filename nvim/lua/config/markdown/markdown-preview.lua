_G.OpenMarkdownPreviewBare = function(url)
   vim.fn.jobstart({
      "firefox",
      "--no-remote",
      "--new-instance",
      "--profile", vim.fn.expand("~/.mozilla/firefox/markdown-preview"),
      "--new-window",
      "--width", "1200",
      "--height", "900",
      "--kiosk",
      url,
   })
end
