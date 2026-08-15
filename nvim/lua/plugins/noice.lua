-- ~/.config/nvim/lua/plugins/noice.lua
return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      -- Route shell command (:!) output to a scrollable split instead of
      -- relying on noice's default popup rendering (buggy for shell_out on 0.11+)
      opts.routes = opts.routes or {}
      table.insert(opts.routes, 1, {
        filter = {
          event = "msg_show",
          kind = "shell_out", -- Neovim 0.11+; see note below for older versions
        },
        view = "split",
      })

      -- Reposition the cmdline popup to the vertical center of the screen
      opts.views = opts.views or {}
      opts.views.cmdline_popup = vim.tbl_deep_extend("force", opts.views.cmdline_popup or {}, {
        border = {
          style = "none",
        },
        position = {
          row = "50%",
          col = "50%",
        },
        size = {
          min_width = 60,
          width = "auto",
          height = "auto",
        },
      })

      -- Keep the completion popup menu anchored just below the cmdline
      opts.views.cmdline_popupmenu = vim.tbl_deep_extend("force", opts.views.cmdline_popupmenu or {}, {
        position = {
          row = "55%",
          col = "50%",
        },
      })

      opts.cmdline = vim.tbl_deep_extend("force", opts.cmdline or {}, {
        format = {
          cmdline = { icon = "🧼" }, -- the ":" command prompt (what you saw in your earlier screenshot)
          search_down = { icon = "🔍" },
          search_up = { icon = "🔍 " },
          filter = { icon = "$" },
          lua = { icon = "" },
          help = { icon = "?" },
        },
      })
    end,
  },
}
