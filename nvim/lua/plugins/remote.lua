return {
  {
    "amitds1997/remote-nvim.nvim",
    version = "*",
    cmd = { "RemoteStart", "RemoteStop", "RemoteInfo", "RemoteCleanup", "RemoteConfigDel", "RemoteLog" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim", -- used to select SSH hosts
    },
    opts = {},
  },
}
