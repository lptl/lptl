return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      border = false,
      borderchars = { " ", " ", " ", " ", " ", " ", " ", " " }, -- fallback: blank border chars
    },
  },
  config = function(_, opts)
    require("telescope").setup(opts)

    local function set_transparent()
      vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "NONE", bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "NONE", bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "NONE", bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "NONE", bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "NONE", bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
    end

    set_transparent()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_transparent })
  end,
}
