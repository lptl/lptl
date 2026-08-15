-- ~/.config/nvim/lua/plugins/neotree.lua
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        hijack_netrw_behavior = "open_current", -- Opens neo-tree in the active buffer on :e <dir>
      },
    },
  },
}
