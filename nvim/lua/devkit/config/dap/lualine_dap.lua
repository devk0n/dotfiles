local colors = require("catppuccin.palettes").get_palette("mocha")

local function build_theme()
   local theme = require("lualine.themes.catppuccin")

   if _G.DebugModeActive then
      -- Normal
      theme.normal.a = { fg = colors.base, bg = colors.red, gui = "bold" }
      theme.normal.b = { fg = colors.red, bg = colors.surface1 }

      -- Insert
      theme.insert.a = { fg = colors.base, bg = colors.red, gui = "bold" }
      theme.insert.b = { fg = colors.red, bg = colors.surface1 }

      -- Visual
      theme.visual.a = { fg = colors.base, bg = colors.red, gui = "bold" }
      theme.visual.b = { fg = colors.red, bg = colors.surface1 }

      -- Replace
      theme.replace.a = { fg = colors.base, bg = colors.red, gui = "bold" }
      theme.replace.b = { fg = colors.red, bg = colors.surface1 }

      -- Command
      theme.command.a = { fg = colors.base, bg = colors.red, gui = "bold" }
      theme.command.b = { fg = colors.red, bg = colors.surface1 }
   else
      -- Normal
      theme.normal.a = { fg = colors.base, bg = colors.blue, gui = "bold" }
      theme.normal.b = { fg = colors.blue, bg = colors.surface1 }

      -- Insert
      theme.insert.a = { fg = colors.base, bg = colors.green, gui = "bold" }
      theme.insert.b = { fg = colors.green, bg = colors.surface1 }

      -- Visual
      theme.visual.a = { fg = colors.base, bg = colors.mauve, gui = "bold" }
      theme.visual.b = { fg = colors.mauve, bg = colors.surface1 }

      -- Replace
      theme.replace.a = { fg = colors.base, bg = colors.red, gui = "bold" }
      theme.replace.b = { fg = colors.red, bg = colors.surface1 }

      -- Command
      theme.command.a = { fg = colors.base, bg = colors.peach, gui = "bold" }
      theme.command.b = { fg = colors.peach, bg = colors.surface1 }
   end
   return theme
end

return build_theme

