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

    local function cwd()
      return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    end

    local function project_dir()
      local root = LazyVim.root.get()
      return vim.fn.fnamemodify(root, ":~")
    end

    opts.sections.lualine_b = { cwd }
    opts.sections = {
      lualine_a = { "mode" },
      lualine_b = { project_dir },
      lualine_c = { { "filename", path = 3 } },
      lualine_x = {
        {
          "diagnostics",
          sources = { "nvim_lsp", "nvim_diagnostic" },
          sections = { "error", "warn", "info", "hint" },
          symbols = { error = "E ", warn = "W ", info = "I ", hint = "H " },
          update_in_insert = false,
          always_visible = false,
          on_click = function()
            vim.diagnostic.open_float()
          end,
        },
      },
      lualine_y = { { "branch", icon = "" } },
      lualine_z = { "location" },
    }
  end,
}
