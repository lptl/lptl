return {
  "folke/snacks.nvim",
  opts = {
    dashboard = { enabled = false },
    indent = { enabled = false },
    notifier = {
      enabled = true,
      timeout = 7000,
      margin = {
        top = 1, -- Space from the top edge
        right = 1, -- Space from the right edge
        bottom = 1, -- Space from the bottom edge
      },
    },
    styles = {
      notification = {
        border = "none",
      },
    },
    picker = {
      prompt = " ▶ ",
      layouts = {
        default = {
          layout = {
            box = "horizontal",
            width = 0.8,
            min_width = 120,
            height = 0.6,
            border = "none",
            {
              width = 0.5,
              box = "vertical",
              border = "top", -- Top border to render the title
              title = " {title} {live} {flags} ",
              title_pos = "center",
              { win = "input", height = 1, border = "none" },
              { win = "list", border = "none" },
            },
            {
              win = "preview",
              -- title = " {preview} ",
              -- width = 0.5,
              -- border = "top",
              -- title_pos = "center",
            },
          },
        },
      },
    },
  },
}
