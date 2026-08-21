-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
  {
    "slugbyte/lackluster.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      tweak_syntax = {
        comment = "#888888", -- or lackluster.color.gray4 / gray5, etc.
      },
      tweak_background = {
        normal = "none",
        telescope = "none",
        menu = "none",
        popup = "none",
      },
      tweak_highlight = {
        ["CursorLine"] = {
          overwrite = true, -- fully replace lackluster's default, not just extend it
          bg = "#2a2a2a", -- or lackluster.color.gray3, or "none" for transparent
        },
        ["MsgArea"] = {
          overwrite = true,
          fg = "#dddddd", -- or lackluster.color.gray9, whatever you want
          bg = "none", -- add this too if you also want it transparent
        },
        ["NoiceCmdlinePopup"] = {
          overwrite = true,
          fg = "#dddddd", -- or lackluster.color.gray3, or "none" for terminal-transparent
        },
        ["NoiceCmdlinePopupBorder"] = {
          overwrite = true,
          fg = "#dddddd", -- match so the border blends in, or leave unset for default border color
        },
      },
      -- tweak_color allows you to overwrite the default colors in the lackluster theme
      tweak_color = {
        -- you can set a value to a custom hexcode like '#aaaa77' (hashtag required)
        -- or if the value is 'default' or nil it will use lackluster's default color
        lack = "#cdc9c9",
        luster = "#cdc9c9",
        orange = "#92b2a2",
        yellow = "#fafad2",
        green = "#92b2a2",
        blue = "#87ceeb",
        red = "#fafad2",
        -- WARN: Watchout! messing with grays is probs a bad idea, its very easy to shoot yourself in the foot!
        black = "#232425",
        gray1 = "#222222",
        gray2 = "#444444",
        gray3 = "#666666",
        gray4 = "#AAAAAA",
        gray5 = "#AAAAAA",
        gray6 = "#AAAAAA",
        gray7 = "#cdc9c9",
        -- gray8 = "default",
        gray9 = "#EEEEEE",
      },
      disable_plugin = {},
    },
    config = function(_, opts)
      -- !must call setup() before setting the colorscheme!
      require("lackluster").setup(opts)
      vim.cmd.colorscheme("lackluster")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "lackluster",
    },
  },
}
