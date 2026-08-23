return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          border = "none",
        },
        documentation = {
          window = {
            border = "none",
          },
        },
      },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)

      local function set_transparent()
        vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "none" })
        vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "none" })
        vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "none" })
        vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "none" })
        vim.api.nvim_set_hl(0, "BlinkCmpLabel", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
        vim.api.nvim_set_hl(0, "BlinkCmpScrollBarThumb", { bg = "none" })
        vim.api.nvim_set_hl(0, "BlinkCmpScrollBarGutter", { bg = "none" })
      end

      set_transparent()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_transparent })
    end,
  },
}
