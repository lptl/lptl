-- ~/.config/nvim/lua/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local transparent = {
      a = { bg = "none" },
      b = { bg = "none" },
      c = { bg = "none" },
    }
    opts.options = opts.options or {}
    opts.options.theme = {
      normal = { a = transparent.a, b = transparent.b, c = transparent.c },
      insert = { a = transparent.a, b = transparent.b, c = transparent.c },
      visual = { a = transparent.a, b = transparent.b, c = transparent.c },
      replace = { a = transparent.a, b = transparent.b, c = transparent.c },
      command = { a = transparent.a, b = transparent.b, c = transparent.c },
      inactive = { a = transparent.a, b = transparent.b, c = transparent.c },
    }
    opts.options.component_separators = ""
    opts.options.section_separators = ""
  end,
}
