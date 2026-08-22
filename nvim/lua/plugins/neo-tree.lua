return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    opts.window = opts.window or {}
    opts.window.mappings = opts.window.mappings or {}

    -- Bind "-" to navigate up to parent directory
    opts.window.mappings["-"] = "navigate_up"
  end,
}
