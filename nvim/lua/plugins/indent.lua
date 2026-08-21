return {
  -- For LazyVim with snacks.nvim (Newer versions)
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        enabled = false,
      },
    },
  },

  -- For indent-blankline (Classic LazyVim)
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },

  -- For scope animation lines (mini.indentscope)
  {
    "nvim-mini/mini.indentscope",
    enabled = false,
  },
}
