return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    -- Opens neo-tree in the active buffer on :e <dir>
    opts.filesystem = opts.filesystem or {}
    opts.filesystem.hijack_netrw_behavior = "open_current"

    -- Bind "-" to navigate up to parent directory
    opts.window = opts.window or {}
    opts.window.mappings = opts.window.mappings or {}
    opts.window.mappings["-"] = "navigate_up"
  end,
}
