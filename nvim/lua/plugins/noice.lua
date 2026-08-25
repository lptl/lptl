return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.routes = opts.routes or {}
      table.insert(opts.routes, 1, {
        filter = {
          event = "msg_show",
          kind = "shell_out",
        },
        view = "split",
      })

      opts.views = opts.views or {}
      opts.views.cmdline_popup = vim.tbl_deep_extend("force", opts.views.cmdline_popup or {}, {
        border = { style = "none" },
        position = { row = "50%", col = "50%" },
        size = { min_width = 60, width = "auto", height = "auto" },
        padding = { 0, 1 },
        win_options = {
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
        },
      })
      opts.views.cmdline_popupmenu = vim.tbl_deep_extend("force", opts.views.cmdline_popupmenu or {}, {
        position = { row = "55%", col = "50%" },
        border = { style = "none" },
      })

      -- Bottom, borderless, full-width bar -- same look as native "/" search.
      -- Defined explicitly (not via `view = "cmdline"` aliasing) because the
      -- substitute confirm dialog (kind = "confirm_sub") always renders via
      -- the "confirm" view and ignores opts.routes overrides
      -- (see https://github.com/folke/noice.nvim/issues/1185), so the view
      -- itself has to carry the bottom-bar styling directly.
      local bottom_bar = {
        backend = "popup",
        relative = "editor",
        focusable = false,
        position = { row = "100%", col = "0%" },
        size = { width = "100%", height = "auto" },
        border = { style = "none" },
        win_options = {
          winhighlight = "Normal:MsgArea,FloatBorder:MsgArea",
        },
      }
      opts.views.confirm = bottom_bar
      opts.views.input = vim.tbl_deep_extend("force", {}, bottom_bar, { focusable = true })

      opts.cmdline = vim.tbl_deep_extend("force", opts.cmdline or {}, {
        format = {
          cmdline = { icon = "" },
          search_down = { icon = "" },
          search_up = { icon = "" },
          filter = { icon = "" },
          lua = { icon = "" },
          help = { icon = "" },
          -- The two prompts of the `<leader>r` replace flow: rendered in the
          -- same minimal, borderless bottom bar as search (no icons).
          replace_target = {
            pattern = "^Replace:%s*",
            icon = "",
            lang = "regex",
            view = "cmdline",
          },
          replace_sub = {
            pattern = "^With:%s*",
            icon = "",
            lang = "text",
            view = "cmdline",
          },
        },
      })

      opts.messages = vim.tbl_deep_extend("force", opts.messages or {}, {
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
      })

      opts.lsp = vim.tbl_deep_extend("force", opts.lsp or {}, {
        progress = { enabled = false },
      })
    end,
  },
}
