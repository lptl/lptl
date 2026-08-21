return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      mode = "buffers",
      themable = true,

      -- minimal indicators
      numbers = "none",
      indicator = {
        icon = "│", -- thin bar instead of a block/underline
        style = "icon",
      },

      -- reduce icon clutter
      show_buffer_icons = false,
      show_buffer_close_icons = false,
      show_close_icon = false,
      show_tab_indicators = false,
      color_icons = false,

      modified_icon = "●",
      buffer_close_icon = "",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",

      -- keep names short and consistent, avoid the ugly path-letter truncation
      max_name_length = 16,
      max_prefix_length = 10,
      tab_size = 14,
      truncate_names = true,

      -- thin, flat separators instead of slanted blocks
      separator_style = "thin",

      -- keep diagnostics quiet — just a small count, no icons
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count)
        return "(" .. count .. ")"
      end,

      always_show_bufferline = true,
      show_duplicate_prefix = false, -- avoid the letter-by-letter path spam you saw

      offsets = {
        {
          filetype = "neo-tree",
          text = "Explorer",
          highlight = "Directory",
          text_align = "left",
          separator = false,
        },
      },
    },

    -- muted, low-contrast highlight overrides for a flatter look
    highlights = {
      fill = { bg = "NONE" },
      background = { fg = "#6c7086", bg = "NONE" },

      buffer_selected = {
        fg = "#cdd6f4",
        bg = "NONE",
        bold = false,
        italic = false,
      },
      buffer_visible = {
        fg = "#7f849c",
        bg = "NONE",
      },

      separator = { fg = "NONE", bg = "NONE" },
      separator_selected = { fg = "NONE", bg = "NONE" },
      separator_visible = { fg = "NONE", bg = "NONE" },

      indicator_selected = { fg = "#89b4fa", bg = "NONE" },

      modified = { fg = "#f9e2af", bg = "NONE" },
      modified_selected = { fg = "#f9e2af", bg = "NONE" },

      duplicate = { fg = "#6c7086", bg = "NONE", italic = true },
      duplicate_selected = { fg = "#cdd6f4", bg = "NONE", italic = true },
    },
  },
}
